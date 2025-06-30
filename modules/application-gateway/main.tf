####################
# Provider section #
####################

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.98.0"
    }
  }
}

provider "azurerm" {
  features {}
}

########################
# Data sources section #
########################

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config
# Fetches the current Azure client configuration, which includes details like tenant ID.
data "azurerm_client_config" "current" {}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault
# Retrieves an existing Key Vault specified by variables for storing sensitive information.
data "azurerm_key_vault" "shared_kv" {
  name                = var.shared_key_vault_name
  resource_group_name = var.shared_key_vault_resource_group
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_certificate
# Fetches a certificate from the existing Key Vault to be used with the Application Gateway.
data "azurerm_key_vault_certificate" "shared_cert" {
  name         = var.shared_certificate_name
  key_vault_id = data.azurerm_key_vault.shared_kv.id
}

#####################
# Resources section #
#####################

#https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity
# Creates a user-assigned managed identity for the Application Gateway, allowing it to authenticate to the keyvault access policy.
resource "azurerm_user_assigned_identity" "appgw_identity" {
  resource_group_name = var.resource_group
  location            = var.location
  name                = "${var.name}-identity"
}
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip
# Defines a public IP address for the Application Gateway, using a static allocation method and a standard SKU.
resource "azurerm_public_ip" "pipagw" {
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
  name                = "${var.name}-publicip"
  resource_group_name = var.resource_group
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_gateway
# Configures the Application Gateway, including settings for frontend IP, backend pools, and routing rules.
resource "azurerm_application_gateway" "agw" {
  lifecycle {
    ignore_changes = [
      backend_address_pool,
      backend_http_settings,
      frontend_ip_configuration,
      gateway_ip_configuration,
      http_listener,
      ssl_certificate,
      redirect_configuration,
      url_path_map,
      frontend_port,
      probe,
      request_routing_rule,
      tags
    ]
  }
  name                = var.name
  resource_group_name = var.resource_group
  location            = var.location
  tags                = var.tags

  sku {
    name = "Standard_v2"
    tier = "Standard_v2"
  }

  autoscale_configuration {
    min_capacity = 1
    max_capacity = 5
  }

  # Frontend IP configuration using a public IP address
  frontend_ip_configuration {
    name                 = "appGwPublicFrontendIp1"
    public_ip_address_id = azurerm_public_ip.pipagw.id
  }

  # Frontend IP configuration using a private subnet.
  frontend_ip_configuration {
    name                            = "${var.name}-priv-ip"
    subnet_id                       = var.subnet_id
    private_ip_address_allocation   = "Static"
    private_ip_address              = var.appgw_private_ip
    private_link_configuration_name = "pl-appgw-${var.environment}"
  }

  # Gateway IP configuration specifying the subnet for the Application Gateway.
  gateway_ip_configuration {
    name      = "appGatewayIpConfig"
    subnet_id = var.subnet_id
  }

  # Defines frontend ports for HTTP traffic.
  frontend_port {
    name = "port_80"
    port = 80
  }

  # Defines frontend ports for HTTPS traffic.
  frontend_port {
    name = "port_443"
    port = 443
  }

  # Private Link configuration for secure access to resources.
  private_link_configuration {
    name = "pl-appgw-${var.environment}"

    ip_configuration {
      name                          = "privateLinkIpConfig1"
      subnet_id                     = var.support_subnet_id
      private_ip_address_allocation = "Dynamic"
      primary                       = true
    }
  }

  # Name of the backend pool where traffic is routed
  backend_address_pool {
    name = "kubernetes-backend"
  }

  backend_http_settings {
    name                  = "backend-http"
    cookie_based_affinity = "Disabled" # Disables cookie-based affinity for session persistence
    port                  = 80         # Port used to connect to backend servers
    protocol              = "Http"     # Protocol used to connect to backend servers
    request_timeout       = 60         # Timeout setting for requests to backend servers (in seconds)
  }

  # Assigns the created identity to the gateway
  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.appgw_identity.id]
  }

  # References SSL certificate from Key Vault
  ssl_certificate {
    name                = "dflbuscert"
    key_vault_secret_id = data.azurerm_key_vault_certificate.shared_cert.secret_id
  }


  # Listener for HTTP traffic
  http_listener {
    name                           = "main-http"
    frontend_ip_configuration_name = "${var.name}-priv-ip"
    frontend_port_name             = "port_80"
    protocol                       = "Http"
  }

  # Listener for HTTPS traffic and associates SSL certificate with the listener
  http_listener {
    name                           = "main-https"
    frontend_ip_configuration_name = "${var.name}-priv-ip"
    frontend_port_name             = "port_443"
    protocol                       = "Https"
    ssl_certificate_name           = "dflbuscert"
  }

  # Request Routing Rules
  request_routing_rule {
    name                       = "https"
    rule_type                  = "Basic"
    http_listener_name         = "main-https"
    backend_address_pool_name  = "kubernetes-backend"
    backend_http_settings_name = "backend-http"
    priority                   = 20
  }

  # Configures redirection from HTTP to HTTPS
  redirect_configuration {
    name                 = "http-redirect"
    redirect_type        = "Permanent"
    include_path         = true
    include_query_string = true
    target_listener_name = "main-https"
  }

  request_routing_rule {
    name                        = "http"
    rule_type                   = "Basic"
    http_listener_name          = "main-http"
    redirect_configuration_name = "http-redirect" # Redirects HTTP traffic to HTTPS listener 
    priority                    = 10
  }

  depends_on = [var.apgw_depends_on]
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy
# Grants permissions to the Application Gateway's identity to access secrets and certificates from the existing KeyVault.
resource "azurerm_key_vault_access_policy" "appgw_policy" {
  key_vault_id = data.azurerm_key_vault.shared_kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_user_assigned_identity.appgw_identity.principal_id

  secret_permissions = [
    "Get",
    "List",
    "Set"
  ]

  certificate_permissions = [
    "Get",
    "List",
    "Create",
    "Delete",
    "DeleteIssuers",
    "GetIssuers",
    "Import",
    "ListIssuers",
    "ManageContacts",
    "ManageIssuers",
    "Recover",
    "Restore",
    "SetIssuers",
    "Update",
    "Backup"
  ]
}
