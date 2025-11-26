param(
  [string]$subscriptionId = "Pay-As-You-Go",
  [string]$resourceGroup = "pg-crud-demo-rg",
  [string]$location = "eastus",
  [string]$vnetName = "pg-vnet",
  [string]$subnetName = "pg-subnet",
  [string]$pgServerName = "pgcrudserver$(Get-Random -Maximum 99999)",
  [string]$adminUser = "pgadmin",
  [string]$adminPassword = "P@ssw0rd12345!"
)

Write-Output "Setting subscription..."
az account set --subscription $subscriptionId

Write-Output "Creating resource group $resourceGroup ..."
az group create --name $resourceGroup --location $location

Write-Output "Creating VNet and subnet..."
az network vnet create --resource-group $resourceGroup --name $vnetName --address-prefixes 10.10.0.0/16 --subnet-name $subnetName --subnet-prefix 10.10.1.0/24

Write-Output "Creating PostgreSQL Flexible Server (private) - this may take several minutes..."
az postgres flexible-server create `
  --resource-group $resourceGroup `
  --name $pgServerName `
  --admin-user $adminUser `
  --admin-password $adminPassword `
  --location $location `
  --vnet $vnetName `
  --subnet $subnetName `
  --sku-name Standard_B1ms `
  --public-access None `
  --yes

Write-Output "Creating sample database 'demo_db'..."
az postgres flexible-server db create --resource-group $resourceGroup --server-name $pgServerName --database-name demo_db

Write-Output "Output:"
Write-Output "  Resource Group: $resourceGroup"
Write-Output "  PostgreSQL Server: $pgServerName"
Write-Output "  Admin user: $adminUser"
Write-Output "Remember to set Function App settings to connect to the DB (PG_HOST, PG_DB, PG_USER, PG_PASSWORD)."
