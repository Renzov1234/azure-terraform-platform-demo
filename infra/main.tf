locals {
  name_prefix = "${var.project_name}-${var.environment}"
}

resource "random_string" "suffix" {
  length  = 6
  upper   = false
  special = false
}

# We deploy into an existing RG to keep access tight (SP scoped to this RG).
data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

resource "azurerm_storage_account" "sa" {
  name                = replace("${var.project_name}${var.environment}${random_string.suffix.result}", "-", "")
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location

  account_tier             = "Standard"
  account_replication_type = "LRS"

  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false

  tags = {
    project = var.project_name
    env     = var.environment
  }
}

resource "azurerm_service_plan" "plan" {
  name                = "${local.name_prefix}-plan"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location

  os_type  = "Linux"
  sku_name = "Y1" # Consumption -> cost-safe
  tags = {
    project = var.project_name
    env     = var.environment
  }
}

resource "azurerm_application_insights" "ai" {
  name                = "${local.name_prefix}-ai"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  application_type    = "web"

  retention_in_days                     = 30
  daily_data_cap_in_gb                  = var.app_insights_daily_cap_gb
  daily_data_cap_notifications_disabled = false

  tags = {
    project = var.project_name
    env     = var.environment
  }
}

resource "azurerm_linux_function_app" "fn" {
  name                = "${local.name_prefix}-fn-${random_string.suffix.result}"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location

  service_plan_id            = azurerm_service_plan.plan.id
  storage_account_name       = azurerm_storage_account.sa.name
  storage_account_access_key = azurerm_storage_account.sa.primary_access_key

  https_only = true

  identity {
    type = "SystemAssigned"
  }

  site_config {
    application_stack {
      node_version = "18"
    }
  }

  app_settings = {
    FUNCTIONS_EXTENSION_VERSION = "~4"
    FUNCTIONS_WORKER_RUNTIME    = "node"
    WEBSITE_RUN_FROM_PACKAGE    = "1"

    # App Insights: keep it but protect cost
    APPLICATIONINSIGHTS_CONNECTION_STRING = azurerm_application_insights.ai.connection_string
    APPINSIGHTS_SAMPLING_PERCENTAGE       = "25" # reduce ingestion
    AzureWebJobsStorage                   = azurerm_storage_account.sa.primary_connection_string

    # Our app config:
    EXPENSES_TABLE_NAME = "expenses"
  }

  tags = {
    project = var.project_name
    env     = var.environment
  }
}
