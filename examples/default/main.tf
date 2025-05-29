module "vnet-spoke" {
  source              = "../../"
  resource_group_name = local.spoke_rg_name
  location            = var.location
  spoke_vnet_details  = local.spoke_vnet_details
  hub_vnet_details    = local.hub_vnet_details
  peering_details     = local.peering_details
}
