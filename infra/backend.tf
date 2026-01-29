terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tfstate-demo"
    storage_account_name = "sttfstate260806"
    container_name       = "tfstate"
    key                  = "demo-functions-dev.tfstate"
  }
}
