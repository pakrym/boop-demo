resource frontend 'Microsoft.Web/sites@2021-01-15' = {
  name: '${resourceGroup().name}frontend'
  location: resourceGroup().location
  properties: {
    serverFarmId: appService.id
  }
  identity: {
    type: 'SystemAssigned'
  }

  resource webappappsettings 'config' = {
    name: 'appsettings'
    properties: {
      'storageEndpoint': storageacc.properties.primaryEndpoints.blob
      'WEBSITE_RUN_FROM_PACKAGE': '1'
    }
  }
}

resource appService 'Microsoft.Web/serverFarms@2020-06-01' = {
  name: '${resourceGroup().name}appService'
  location: resourceGroup().location
  sku: {
    name: 'F1'
  }
}

resource storageacc 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: '${resourceGroup().name}storageacc'
  location: resourceGroup().location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
}

resource storageAssignment 'Microsoft.Authorization/roleAssignments@2018-01-01-preview' = {
  name: guid(resourceGroup().name)
  properties: {
    principalId: frontend.identity.principalId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'ba92f5b4-2d11-453d-a403-e96b0029c9fe')
  }
}
