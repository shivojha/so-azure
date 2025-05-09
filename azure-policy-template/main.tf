# Azure Policy as Code Example for Enterprise Use

provider "azurerm" {
  features {}
}

provider "azuread" {
  tenant_id = var.tenant_id
}

resource "azurerm_resource_group" "policy" {
  name     = "rg-policy-definitions"
  location = var.location
}

resource "azurerm_policy_definition" "deny_public_ip" {
  name         = "deny-public-ip-vm"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deny Public IP for VMs"

  policy_rule = jsonencode({
    "if": {
      "allOf": [
        { "field": "type", "equals": "Microsoft.Network/networkInterfaces" },
        { "field": "Microsoft.Network/networkInterfaces/ipConfigurations[*].publicIpAddress.id", "exists": "true" }
      ]
    },
    "then": {
      "effect": "deny"
    }
  })

  metadata = jsonencode({
    "category": "Network"
  })
}

resource "azurerm_policy_definition" "require_tag" {
  name         = "require-environment-tag"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Require 'Environment' Tag on Resources"

  policy_rule = jsonencode({
    "if": {
      "field": "tags.Environment",
      "exists": "false"
    },
    "then": {
      "effect": "deny"
    }
  })

  parameters = jsonencode({
    "tagName": {
      "type": "String",
      "metadata": {
        "description": "Tag name to enforce",
        "displayName": "Tag Name"
      }
    }
  })

  metadata = jsonencode({
    "category": "Tags"
  })
}

resource "azurerm_policy_assignment" "assign_deny_public_ip" {
  name                 = "enforce-deny-public-ip"
  policy_definition_id = azurerm_policy_definition.deny_public_ip.id
  scope                = var.target_scope
  description          = "Ensure no public IPs are assigned to NICs."
  display_name         = "Enforce Public IP Denial on NICs"
}

resource "azurerm_policy_assignment" "assign_require_tag" {
  name                 = "enforce-tag-requirement"
  policy_definition_id = azurerm_policy_definition.require_tag.id
  scope                = var.target_scope
  description          = "Ensure Environment tag is present on all resources."
  display_name         = "Require Environment Tag"

  parameters = jsonencode({
    tagName = { "value": "Environment" }
  })
}
