terraform {
  backend "azurerm" {
    # Configure these values in your backend config or pipeline secrets.
    resource_group_name  = ""
    storage_account_name = ""
    container_name       = ""
    key                  = "terraform.tfstate"
  }
}
