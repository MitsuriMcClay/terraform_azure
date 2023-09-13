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

# VM Admin User名
variable "admin_username" {

  default = "azureuser"

}

# VM Admin Password
variable "admin_password" {

}

# PostgreSQLサーバー名
variable "postgresql_server_name" {

  default = "mcclaytest-pg-server"

}

# PostgreSQLログインユーザー名
variable "administrator_login" {

}

# PostgreSQLログインユーザーPW
variable "administrator_login_password" {

}

# PostgreSQLバージョン
variable "postgresql_version" {

  default = "11"
}

# PostgreSQL　sku名
variable "postgresql_sku_name" {

  default = "B_Gen5_1"
}

# PostgreSQL db名
variable "azurerm_postgresql_database" {

  default = "postgresql-db"

}