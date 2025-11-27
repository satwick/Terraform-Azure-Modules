####################
# Locals           #
####################

locals {
  private_dns_zones = {
    servicebus-windows-net       = "privatelink.servicebus.windows.net"
    westeurope-kusto-windows-net = "privatelink.westeurope.kusto.windows.net"
  }
}

####################
# Provider section #
####################

terraform {
  backend "azurerm" {}

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.73.0"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "azurerm" {
  features {}
  alias           = "target"
  subscription_id = var.target_subscription_id
  client_id       = var.client_id_target
  client_secret   = var.client_secret_target
  tenant_id       = var.tenant_id_target
}

#####################
# Data section 			#
#####################

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/dns_zone
data "azurerm_private_dns_zone" "servicebus-windows-net" {
  provider = azurerm.target

  name                = local.private_dns_zones["servicebus-windows-net"]
  resource_group_name = var.target_dns_resource_group_name
}

data "azurerm_private_dns_zone" "westeurope-kusto-windows-net" {
  provider = azurerm.target

  name                = local.private_dns_zones["westeurope-kusto-windows-net"]
  resource_group_name = var.target_dns_resource_group_name
}

#####################
# Resources section #
#####################

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group
resource "azurerm_resource_group" "iot" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone
resource "azurerm_private_dns_zone" "private_dns_zones" {
  for_each            = local.private_dns_zones
  name                = each.value
  resource_group_name = azurerm_resource_group.iot.name
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link
resource "azurerm_private_dns_zone_virtual_network_link" "servicesbus-windows-net" {
  provider = azurerm.target

  name                  = "${local.private_dns_zones.servicebus-windows-net}-test-link"
  resource_group_name   = var.target_dns_resource_group_name
  private_dns_zone_name = local.private_dns_zones["servicebus-windows-net"]
  virtual_network_id    = module.iot_vnet.vnet_id
}

resource "azurerm_private_dns_zone_virtual_network_link" "westeurope-kusto-windows-net" {
  provider = azurerm.target

  name                  = "${local.private_dns_zones.westeurope-kusto-windows-net}-test-link"
  resource_group_name   = var.target_dns_resource_group_name
  private_dns_zone_name = local.private_dns_zones["westeurope-kusto-windows-net"]
  virtual_network_id    = module.iot_vnet.vnet_id
}

module "iot_vnet" {
  source = "../../modules/v-net"

  name                = var.iot_vnet_name
  location            = azurerm_resource_group.iot.location
  resource_group_name = azurerm_resource_group.iot.name
  address_space       = var.iot_vnet_address_space

  subnets = {
    support-snet = {
      address_prefix                                = [var.support_snet_address_prefix]
      delegation                                    = []
      service_endpoints                             = []
      private_link_service_network_policies_enabled = true
      private_endpoint_network_policies_enabled     = false
    },
    iot-snet = {
      address_prefix                                = [var.iot_snet_address_prefix]
      delegation                                    = []
      service_endpoints                             = []
      private_link_service_network_policies_enabled = true
      private_endpoint_network_policies_enabled     = false
    }
  }

  tags = var.tags
}

# module "eventhub" {
#   # source = "../../modules/eventhub" # Module missing in this repo
#   source = "git::https://git.t3.daimlertruck.com/DFL-BUS/tf-module-eventhub.git?ref=v1.1.0"
#
#   name                = var.event_hub_namespace_name
#   location            = azurerm_resource_group.iot.location
#   resource_group_name = azurerm_resource_group.iot.name
#
#   private_endpoint_name = var.eventhub_private_endpoint_name
#   private_dns_zone_ids = [
#     azurerm_private_dns_zone.private_dns_zones["servicebus-windows-net"].id
#   ]
#   subnet_id = module.iot_vnet.subnet_ids["iot-snet"]
#
#   eventhubs = {
#     "ingest-test" = {
#       name              = "ingest-test"
#       message_retention = 7
#       partition_count   = 1
#     }
#   }
#
#   tags = var.tags
# }

# module "eventhub_pe" {
#   # source = "../../modules/private-endpoint" # Module missing in this repo
#   source = "git::https://git.t3.daimlertruck.com/DFL-BUS/tf-module-privateendpoint.git?ref=v1.0.0"
#
#   providers = {
#     azurerm.target = azurerm.target
#   }
#
#   target_resource_group_name = var.target_resource_group_name
#   target_vnet_name           = var.target_vnet_name
#   target_snet_name           = var.target_snet_name
#   pe_resource_group_name     = var.pe_resource_group_name
#   pe_resource_group_location = var.pe_resource_group_location
#   private_endpoint_name      = "${var.eventhub_private_endpoint_name}-hub"
#   resource_id                = module.eventhub.event_hub_namespace_id
#   subresource_name           = var.eventhub_subresource_name
#   private_dns_zone_ids = [
#     data.azurerm_private_dns_zone.servicebus-windows-net.id
#   ]
# }

# module "adx" {
#   # source = "../../modules/adx" # Module missing in this repo
#   source = "git::https://git.t3.daimlertruck.com/DFL-BUS/tf-module-adx.git?ref=v1.1.1"
#
#   name                = var.adx_name
#   location            = azurerm_resource_group.iot.location
#   resource_group_name = azurerm_resource_group.iot.name
#   database_name       = var.adx_database_name
#   sku                 = var.adx_sku
#   capacity            = var.adx_capacity
#   subnet_id           = module.iot_vnet.subnet_ids["iot-snet"]
#   nsg_name            = var.adx_nsg_name
#
#   eventhubs = {
#     for name, abbreviation in {
#       "ingest-test" = "test"
#       } : name => {
#       kusto_eventhub_data_connection_name = "eventhub-ingest-connection-${abbreviation}"
#       eventhub_id                         = module.eventhub.event_hub_ids[name]
#       eventhub_abbreviation               = abbreviation
#       eventhub_consumer_group             = module.eventhub.eventhub_consumer_groups[name]
#     }
#   }
#
#   private_endpoint_name = var.adx_private_endpoint_name
#   private_dns_zone_ids = [
#     data.azurerm_private_dns_zone.westeurope-kusto-windows-net.id
#   ]
#
#   tags = var.tags
# }
