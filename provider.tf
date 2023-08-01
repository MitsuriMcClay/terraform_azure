# terraform {
#   required_version = ">=0.12"
#   required_providers {
#     azurerm = {
#       source  = "hashicorp/azurerm"
#       version = "~>2.0"

#     tls = {
#       source  = "hashicorp/tls"
#       version = "4.0.4"
#     }
#   }
#     }
# }


# provider "azurerm" {
#   features {}

#   subscription_id = var.subscription_id
#   tenant_id       = var.tenant_id
# }

terraform {
  required_version = ">=0.12"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.4"
    }
  }
}

provider "azurerm" {
  features {}

  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
}