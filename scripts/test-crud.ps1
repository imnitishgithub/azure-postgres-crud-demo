param(
  [string]$functionBaseUrl = "https://<FUNCTION_APP>.azurewebsites.net/api",
  [string]$key = "<FUNCTION_KEY>"
)

$headers = @{ 'x-functions-key' = $key; 'Content-Type' = 'application/json' }

Write-Output "Create an employee..."
$body = @{ name='Test User'; role='Engineer'; salary=90000 } | ConvertTo-Json
Invoke-RestMethod -Method Post -Uri "$functionBaseUrl/Create" -Headers $headers -Body $body | ConvertTo-Json

Write-Output "List employees..."
Invoke-RestMethod -Method Get -Uri "$functionBaseUrl/Read" -Headers $headers | ConvertTo-Json

Write-Output "Update employee id=1..."
$body = @{ name='Test User 2'; role='Senior'; salary=100000 } | ConvertTo-Json
Invoke-RestMethod -Method Put -Uri "$functionBaseUrl/Update?id=1" -Headers $headers -Body $body | ConvertTo-Json

Write-Output "Delete employee id=1..."
Invoke-RestMethod -Method Delete -Uri "$functionBaseUrl/Delete?id=1" -Headers $headers | ConvertTo-Json
