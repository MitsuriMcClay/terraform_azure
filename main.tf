#----------------------------------------
# リソースグループの作成
#----------------------------------------
resource "azurerm_resource_group" "mcclay-rg" {
  name     = var.azurerm_resource_group
  location = var.location
}

#----------------------------------------
# Virtual Networkの作成
#----------------------------------------
resource "azurerm_virtual_network" "mcclay_net" {
  depends_on = [
    azurerm_resource_group.mcclay-rg
  ]
  #force_destroy       = true
  name                = var.virtual_network_name
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.azurerm_resource_group
  #resource_group_name = azurerm_resource_group.mcclay-rg.name
}

#----------------------------------------
# Subnetの作成
#----------------------------------------
resource "azurerm_subnet" "mcclay-subnet" {
  depends_on = [
    azurerm_resource_group.mcclay-rg,
    azurerm_virtual_network.mcclay_net
  ]
  count = 2
  #name = "subnet-1"
  name                = "subnet-${count.index + 1}"
  resource_group_name = var.azurerm_resource_group
  #resource_group_name = azurerm_resource_group.mcclay-rg.name
  virtual_network_name = var.virtual_network_name
  address_prefixes     = [var.address_prefixes[count.index]]
  #address_prefixes     = [var.address_prefixes[count.index]]
  # var.vnet_address_space[count.index]
}

#----------------------------------------
# Public IPの作成
#----------------------------------------
resource "azurerm_public_ip" "pub-ip" {
  depends_on = [
    azurerm_resource_group.mcclay-rg,
    azurerm_virtual_network.mcclay_net
  ]
  count               = 2
  name                = "pub-ip-${count.index + 1}"
  location            = var.location
  resource_group_name = var.azurerm_resource_group
  #resource_group_name = azurerm_resource_group.mcclay-rg.name
  allocation_method = "Dynamic"
}

#----------------------------------------
# ネットワークインターフェイスの作成
#----------------------------------------
resource "azurerm_network_interface" "mcclay-nic" {
  count               = 2
  name                = "mcclay-nic-${count.index + 1}"
  location            = var.location
  resource_group_name = var.azurerm_resource_group
  #delete_on_termination = true
  #create_before_destroy = true
  #resource_group_name = azurerm_resource_group.mcclay-rg.name
  #network_security_group_id = var.azurerm_network_security_group

  ip_configuration {
    name                          = "ip-config"
    subnet_id                     = azurerm_subnet.mcclay-subnet[count.index].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pub-ip[count.index].id
    #public_ip_address_id = azurerm_public_ip.pub-ip.id
  }
}

#----------------------------------------
# Networkセキュリティグループの作成
#----------------------------------------
resource "azurerm_network_security_group" "networksg" {
  depends_on = [
    azurerm_resource_group.mcclay-rg,
    azurerm_virtual_network.mcclay_net
  ]
  name                = "mcclaynsg"
  location            = var.location
  resource_group_name = var.azurerm_resource_group
  #resource_group_name = azurerm_resource_group.mcclay-rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "HTTP"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

#----------------------------------------
# NetworkセキュリティグループとNetworkインターフェイスの紐付け
#----------------------------------------
resource "azurerm_network_interface_security_group_association" "mcclay-test" {
  count                     = 2
  network_interface_id      = azurerm_network_interface.mcclay-nic[count.index].id
  network_security_group_id = azurerm_network_security_group.networksg.id
}

#----------------------------------------
# Virtual Machines作成
#----------------------------------------
resource "azurerm_virtual_machine" "test-vms" {
  depends_on = [
    azurerm_resource_group.mcclay-rg,
    azurerm_virtual_network.mcclay_net
  ]
  count               = 2
  name                = "mcclay-vm-${count.index + 1}"
  location            = var.location
  resource_group_name = var.azurerm_resource_group
  #resource_group_name = azurerm_resource_group.mcclay-rg.name
  network_interface_ids = [azurerm_network_interface.mcclay-nic[count.index].id]
  vm_size               = "Standard_DS1_v2"

  // 使用するイメージ
  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  // ディスク
  storage_os_disk {
    name              = "test-${count.index + 1}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = var.computer_name
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}

#----------------------------------------
# Azure Database for PostgreSQLサーバの作成
#----------------------------------------
resource "azurerm_postgresql_server" "mcclaytest-pg-server" {
  depends_on = [
    azurerm_resource_group.mcclay-rg,
    azurerm_virtual_network.mcclay_net,
    azurerm_network_interface_security_group_association.mcclay-test
  ]
  name                = var.postgresql_server_name
  resource_group_name = var.azurerm_resource_group
  location            = var.location

  administrator_login          = var.administrator_login
  administrator_login_password = var.administrator_login_password

  sku_name = var.postgresql_sku_name
  version  = var.postgresql_version

  storage_mb = 5120

  public_network_access_enabled    = true
  ssl_enforcement_enabled          = true
  ssl_minimal_tls_version_enforced = "TLS1_2"
}

#----------------------------------------
# Azure Database for PostgreSQL データベースの作成
#----------------------------------------
resource "azurerm_postgresql_database" "pg-db" {
  depends_on = [
    azurerm_resource_group.mcclay-rg,
    azurerm_virtual_network.mcclay_net,
    azurerm_postgresql_server.mcclaytest-pg-server
  ]
  name                = var.azurerm_postgresql_database
  resource_group_name = var.azurerm_resource_group
  server_name         = var.postgresql_server_name
  charset             = "utf8"
  collation           = "Japanese_Japan.932"
}