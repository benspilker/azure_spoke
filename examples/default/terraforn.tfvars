location = "eastus2"

biz_shortname = "org"
environment   = "pd"

spoke_address_space = ["10.88.4.0/22"]
spoke_subnets = {
  "app_sn" = {
    name             = "app"
    address_prefixes = ["10.88.4.0/24"]
    security_rules = [{
      access                     = "Allow"
      destination_address_prefix = "*"
      destination_port_range     = "*"
      direction                  = "Inbound"
      name                       = "org-nsgr-https-pd-eus2-01"
      priority                   = 100
      protocol                   = "Tcp"
      source_address_prefix      = "10.88.4.0/24"
      source_port_range          = "443"
      },
      {
        access                     = "Allow"
        destination_address_prefix = "*"
        destination_port_range     = "*"
        direction                  = "Inbound"
        name                       = "org-nsgr-rdp-pd-eus2-01"
        priority                   = 150
        protocol                   = "Tcp"
        source_address_prefix      = "10.88.5.0/24"
        source_port_range          = "3389"
    }]
  }
  "db_sn" = {
    name             = "db"
    address_prefixes = ["10.88.5.0/24"]
    security_rules   = []
  }
}

hub_vnet_details = {
  name                = "org-hub-eastus2-vnet"
  resource_group_name = "org-hub-eastus2"
  hub_subscription_id     = ""
  spoke_subscription_id     = ""
  firewall_ip         = "10.76.1.4"
}

tags = {}