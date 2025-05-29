locals {
  resource_group_name = element(coalescelist(data.azurerm_resource_group.rgrp[*].name, azurerm_resource_group.rg[*].name, [""]), 0)
  location            = element(coalescelist(data.azurerm_resource_group.rgrp[*].location, azurerm_resource_group.rg[*].location, [""]), 0)
}

provider "azurerm" {
  alias           = "hub"
  subscription_id = var.hub_vnet_details.subscription_id
  features {}
}

data "azurerm_resource_group" "rgrp" {
  count = var.create_resource_group ? 0 : 1
  name  = var.resource_group_name
}

resource "azurerm_resource_group" "rg" {
  count    = var.create_resource_group ? 1 : 0
  name     = lower(var.resource_group_name)
  location = var.location
  tags     = merge({ "ResourceName" = format("%s", var.resource_group_name) }, var.tags)
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.spoke_vnet_details.name
  location            = local.location
  resource_group_name = local.resource_group_name
  address_space       = var.spoke_vnet_details.address_space
  tags                = merge({ "ResourceName" = format("%s", var.spoke_vnet_details.name) }, var.tags)
}

resource "azurerm_subnet" "snet" {
  for_each             = var.spoke_vnet_details.subnets
  name                 = each.value.name
  resource_group_name  = local.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = each.value.address_prefixes
}

resource "azurerm_network_security_group" "nsg" {
  for_each            = var.spoke_vnet_details.subnets
  name                = each.value.nsg_name
  resource_group_name = local.resource_group_name
  location            = local.location
  dynamic "security_rule" {
    for_each = each.value.security_rules
    content {
      name                       = security_rule.value["name"]
      priority                   = security_rule.value["priority"]
      direction                  = security_rule.value["direction"]
      access                     = security_rule.value["access"]
      protocol                   = security_rule.value["protocol"]
      source_port_range          = security_rule.value["source_port_range"]
      destination_port_range     = security_rule.value["destination_port_range"]
      source_address_prefix      = security_rule.value["source_address_prefix"]
      destination_address_prefix = security_rule.value["destination_address_prefix"]
    }
  }
  tags = merge({ "ResourceName" = format("%s", each.value.nsg_name) }, var.tags)
}

resource "azurerm_subnet_network_security_group_association" "nsg-assoc" {
  for_each                  = var.spoke_vnet_details.subnets
  subnet_id                 = azurerm_subnet.snet[each.key].id
  network_security_group_id = azurerm_network_security_group.nsg[each.key].id
}

resource "azurerm_route_table" "rt" {
  name                = var.spoke_vnet_details.associated_route_table_name
  resource_group_name = local.resource_group_name
  location            = local.location
  tags                = merge({ "ResourceName" = format("%s", var.spoke_vnet_details.associated_route_table_name) }, var.tags)
}

resource "azurerm_subnet_route_table_association" "rt-assoc" {
  for_each       = var.spoke_vnet_details.subnets
  subnet_id      = azurerm_subnet.snet[each.key].id
  route_table_id = azurerm_route_table.rt.id
}

resource "azurerm_route" "fw-route" {
  count                  = (var.hub_vnet_details.firewall_ip != null) ? 1 : 0
  name                   = var.hub_vnet_details.firewall_route_name
  resource_group_name    = local.resource_group_name
  route_table_name       = azurerm_route_table.rt.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = var.hub_vnet_details.firewall_ip
}

data "azurerm_virtual_network" "hub_vnet" {
  provider            = azurerm.hub
  name                = var.hub_vnet_details.name
  resource_group_name = var.hub_vnet_details.resource_group_name
}

resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  name                         = var.peering_details.spoke_to_hub_peer_name
  resource_group_name          = local.resource_group_name
  virtual_network_name         = azurerm_virtual_network.vnet.name
  remote_virtual_network_id    = data.azurerm_virtual_network.hub_vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = var.peering_details.allow_remote_gateways_from_hub_peer
}

resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  provider                     = azurerm.hub
  name                         = var.peering_details.hub_to_spoke_peer_name
  resource_group_name          = var.hub_vnet_details.resource_group_name
  virtual_network_name         = var.hub_vnet_details.name
  remote_virtual_network_id    = azurerm_virtual_network.vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
}