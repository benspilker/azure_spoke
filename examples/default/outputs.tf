output "spoke_resource_group_name" {
  description = "The name of the resource group for the spoke VNet."
  value       = module.vnet-spoke.resource_group_name
}

output "spoke_vnet_name" {
  description = "The virtual network name of the spoke."
  value       = module.vnet-spoke.virtual_network_name
}

output "spoke_vnet_id" {
  description = "The virtual network id of the spoke."
  value       = module.vnet-spoke.virtual_network_id
}


output "spoke_vnet_address_spaces" {
  description = "The address spaces of the spoke."
  value       = module.vnet-spoke.virtual_network_address_spaces
}

output "spoke_subnet_ids" {
  description = "List of IDs of subnets."
  value       = module.vnet-spoke.subnet_ids
}

output "spoke_subnet_address_prefixes" {
  description = "List of address prefixes for subnets"
  value       = module.vnet-spoke.subnet_address_prefixes
}

output "network_security_group_ids" {
  description = "List of IDs of NSGs"
  value       = module.vnet-spoke.network_security_group_ids
}

output "route_table_name" {
  description = "The name of the route table"
  value       = module.vnet-spoke.route_table_name
}

output "route_table_id" {
  description = "The ID of the route table"
  value       = module.vnet-spoke.route_table_id
}

output "spoke_to_hub_peer_name" {
  description = "Name of the spoke to hub VNet peering"
  value       = module.vnet-spoke.spoke_to_hub_peer_name
}

output "hub_to_spoke_peer_name" {
  description = "Name of the hub to spoke VNet peering"
  value       = module.vnet-spoke.hub_to_spoke_peer_name
}

output "connecting_hub_vnet_name" {
  description = "Name of the connecting hub network"
  value       = module.vnet-spoke.connecting_hub_vnet_name
}

output "connecting_hub_vnet_id" {
  description = "Id of the connecting hub network"
  value       = module.vnet-spoke.connecting_hub_vnet_id
}

output "connecting_hub_subscription_id" {
  description = "Id of the connecting hub network's subscription"
  value       = var.hub_vnet_details.subscription_id
}

output "connecting_hub_resource_group_name" {
  description = "Resource group of the connecting hub network"
  value       = var.hub_vnet_details.resource_group_name
}