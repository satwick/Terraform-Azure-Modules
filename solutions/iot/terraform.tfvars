# Common
location            = "westeurope"
resource_group_name = "dfccc-iottest-rg"
tags = {
  "Environment" : "iottest",
  "Project" : "Dcccc IoT"
}

# VNet
iot_vnet_name          = "dflbus-iottest-vnet"
iot_vnet_address_space = [172.x.x."]

iot_snet_address_prefix     = "172.x.x."
support_snet_address_prefix = "172.x.x."

# Target ENV
target_subscription_id         = "6bcxxx-xxxx-xxxx"
target_resource_group_name     = "dflbus-hub-rg"
target_vnet_name               = "dflbus-hub-vnet"
target_dns_resource_group_name = "dflbus-hub-rg"
target_snet_name               = "support-subnet-sn"
pe_resource_group_name         = "privateendpoints"
pe_resource_group_location     = "Germany West Central"

# EventHub
event_hub_namespace_name       = "dflbus-iottest-evhb-dev"
eventhub_private_endpoint_name = "dflbus-iottest-evhb-dev-pep"

# adx
adx_name                  = "dflbusiotadxtest"
adx_database_name         = "dflbusiotadxtest-db"
adx_nsg_name              = "dflbusiotadxtest-nsg"
adx_private_endpoint_name = "dflbusiotadxtest-pep"
