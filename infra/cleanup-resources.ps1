param(
  [string]$resourceGroup = "pg-crud-demo-rg"
)
Write-Output "Deleting resource group $resourceGroup ..."
az group delete --name $resourceGroup --yes --no-wait
Write-Output "Requested deletion. Resources will be removed asynchronously."
