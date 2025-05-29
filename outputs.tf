output "resource_group_name" {
  description = "The name of the resource group in which resources are created"
  value       = element(coalescelist(data.azurerm_resource_group.rgrp[*].name, azurerm_resource_group.rg[*].name, [""]), 0)
}

output "resource_group_id" {
  description = "The id of the resource group in which resources are created"
  value       = element(coalescelist(data.azurerm_resource_group.rgrp[*].name, azurerm_resource_group.rg[*].id, [""]), 0)
}

output "resource_group_location" {
  description = "The location of the resource group in which resources are created"
  value       = element(coalescelist(data.azurerm_resource_group.rgrp[*].location, azurerm_resource_group.rg[*].location, [""]), 0)
}

output "connecting_hub_vnet_name" {
  description = "Name of the connecting hub network"
  value       = var.hub_vnet_details.name
}

output "connecting_hub_vnet_id" {
  description = "Id of the connecting hub network"
  value       = var.hub_vnet_details.name
}

output "virtual_network_name" {
  description = "The name of the virtual network"
  value       = azurerm_virtual_network.vnet.name
}

output "virtual_network_id" {
  description = "The id of the virtual network"
  value       = azurerm_virtual_network.vnet.id
}

output "virtual_network_address_spaces" {
  description = "Address space(s) for the virtual network"
  value       = azurerm_virtual_network.vnet.address_space
}

output "subnet_ids" {
  description = "List of IDs of subnets"
  value       = { for key, subnet in azurerm_subnet.snet : key => subnet.id }
}

output "subnet_address_prefixes" {
  description = "List of address prefixes of subnets"
  value       = { for key, subnet in azurerm_subnet.snet : key => subnet.address_prefixes }
}

output "network_security_group_ids" {
  description = "The IDs of the network security groups"
  value       = { for key, nsg in azurerm_network_security_group.nsg : key => nsg.id }
}

output "route_table_name" {
  description = "Name of route table associated with the virtual network"
  value       = azurerm_route_table.rt.name
}

output "route_table_id" {
  description = "ID of route table associated with the virtual network"
  value       = azurerm_route_table.rt.id
}

output "spoke_to_hub_peer_name" {
  description = "Name of the spoke to hub VNet peering"
  value       = azurerm_virtual_network_peering.spoke_to_hub.name
}

output "hub_to_spoke_peer_name" {
  description = "Name of the hub to spoke VNet peering"
  value       = azurerm_virtual_network_peering.hub_to_spoke.name
}