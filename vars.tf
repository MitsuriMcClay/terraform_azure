#サブスクリプションID
variable "subscription_id" {

}

#テナントID
variable "tenant_id" {

}

#仮想ネットワーク名
variable "virtual_network_name" {

  default = "mcclay_net"

}

#ロケーション
variable "location" {

  default = "japaneast"

}

#Address prefixes（Subnet Cidr Block)
variable "address_prefixes" {

  default = ["10.0.1.0/24", "10.0.2.0/24"]

}

#リソースグループ名
variable "azurerm_resource_group" {

  default = "mcclay-rg"

}


#Public IP名
variable "azurerm_public_ip" {

  default = "pub-ip"

}

#Networkセキュリティグループ名
variable "azurerm_network_security_group" {

  default = "mcclay-sg"

}

# OSプロフィールコンピュター名
variable "computer_name" {

  default = "test01"

}

# Admin User名
variable "admin_username" {

  default = "azureuser"

}

# Admin Password
variable "admin_password" {

}