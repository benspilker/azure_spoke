locals {
  az_region_abbr_map = {
    "eastus2" = "eus2"
  }
  spoke_rg_name = lower("${var.biz_shortname}-rg-vnet-spoke-${var.environment}-${local.az_region_abbr_map[var.location]}-01")
  spoke_vnet_details = {
    "name"          = lower("${var.biz_shortname}-vnet-spoke-${var.environment}-${local.az_region_abbr_map[var.location]}-01")
    "address_space" = var.spoke_address_space
    "subnets" = { for subnet in var.spoke_subnets : subnet["name"] => {
      "name" : lower("${var.biz_shortname}-snet-${subnet["name"]}-${var.environment}-${local.az_region_abbr_map[var.location]}-01"),
      "address_prefixes" : subnet["address_prefixes"],
      "nsg_name" : lower("${var.biz_shortname}-nsg-${subnet["name"]}-${var.environment}-${local.az_region_abbr_map[var.location]}-01"),
      "security_rules" : subnet["security_rules"] }
    }
    "associated_route_table_name" = lower("${var.biz_shortname}-rt-vnet-spoke-${var.environment}-${local.az_region_abbr_map[var.location]}-01")
  }

  hub_vnet_details = {
    "hub_subscription_id" : var.hub_vnet_details.hub_subscription_id
    "spoke_subscription_id" : var.hub_vnet_details.spoke_subscription_id
    "resource_group_name" : var.hub_vnet_details.resource_group_name
    "name" : var.hub_vnet_details.name
    "firewall_ip" : var.hub_vnet_details.firewall_ip
    "firewall_route_name" : lower("${var.biz_shortname}-udr-vnet-spoke-${var.environment}-${local.az_region_abbr_map[var.location]}-01")
  }
  peering_details = {
    "hub_to_spoke_peer_name" = lower("${var.biz_shortname}-peer-to-spoke-${var.environment}-${local.az_region_abbr_map[var.location]}-01")
    "spoke_to_hub_peer_name" = lower("${var.biz_shortname}-peer-to-hub-${var.environment}-${local.az_region_abbr_map[var.location]}-01")
  }
}