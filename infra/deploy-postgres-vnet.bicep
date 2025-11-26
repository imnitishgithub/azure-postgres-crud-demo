@description('Location for all resources')
param location string = 'eastus'
param rgName string = 'pg-crud-demo-rg'

// VNet
resource vnet 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: 'pgVnet'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.10.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'pgSubnet'
        properties: {
          addressPrefix: '10.10.1.0/24'
        }
      }
    ]
  }
}

// PostgreSQL Flexible Server (basic - public access disabled)
resource pg 'Microsoft.DBforPostgreSQL/flexibleServers@2022-12-01' = {
  name: 'pgserver${uniqueString(rgName)}'
  location: location
  properties: {
    version: '14'
    administratorLogin: 'pgadmin'
    administratorLoginPassword: 'P@ssw0rd12345!'
    sku: {
      name: 'Standard_B1ms'
      tier: 'Burstable'
    }
    storage: {
      storageSizeGB: 32
    }
  }
}
