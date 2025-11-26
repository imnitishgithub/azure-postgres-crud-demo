param(
    [string]$subscriptionId = "<your-subscription-id>",
    [string]$location = "centralus",
    [string]$resourceGroup = "pg-crud-demo-rg",
    [string]$serverName = "pgcrud$(Get-Random)",
    [string]$adminUser = "pgadmin",
    [string]$adminPassword = "Demo@12345",
    [string]$databaseName = "demo_db"
)

# Set subscription
Write-Host "Setting subscription..."
az account set -s $subscriptionId

# Create resource group
Write-Host "Creating resource group $resourceGroup ..."
az group create -n $resourceGroup -l $location | Out-Null

# Create PostgreSQL Flexible Server (Burstable)
Write-Host "Creating public PostgreSQL Flexible Server..."
az postgres flexible-server create `
  --name $serverName `
  --resource-group $resourceGroup `
  --location $location `
  --admin-user $adminUser `
  --admin-password $adminPassword `
  --sku-name Standard_B1ms `
  --tier Burstable `
  --version 14 `
  --public-access 0.0.0.0 `
  --yes

# Wait for server to be ready
Write-Host "Waiting for PostgreSQL server to be ready..."
do {
    $status = az postgres flexible-server show --name $serverName --resource-group $resourceGroup --query "userVisibleState" -o tsv
    Write-Host "Server status: $status"
    Start-Sleep -Seconds 15
} while ($status -ne "Ready")

# Create sample database
Write-Host "Creating database $databaseName ..."
az postgres flexible-server db create `
  --resource-group $resourceGroup `
  --server-name $serverName `
  --database-name $databaseName

# Output connection info
Write-Host "`n🚀 Deployment complete!"
Write-Host "====================================="
Write-Host "Resource Group: $resourceGroup"
Write-Host "PG Server Host: $serverName.postgres.database.azure.com"
Write-Host "PG DB Name:     $databaseName"
Write-Host "PG User:        $adminUser"
Write-Host "PG Password:    $adminPassword"
Write-Host "====================================="
Write-Host "`nNext Steps:"
Write-Host "- Update Function App settings with above values"
Write-Host "- Run test script to verify connection"
