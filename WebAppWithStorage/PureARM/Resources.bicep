param location string 
param baseName string
param identity string = ''

resource frontend 'Microsoft.Web/sites@2021-01-15' = {
  name: '${baseName}frontend'
  location: location
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
  name: '${baseName}appService'
  location: location
  sku: {
    name: 'D1'
  }
}

resource storageacc 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: toLower('${baseName}acc')
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
}

var storageDateContributorRoleId = 'ba92f5b4-2d11-453d-a403-e96b0029c9fe'

module storageAssignmentApp 'Role.bicep' = if (empty(identity)) {
  name: 'storageAssignmentApp'
  params: {
    baseName: baseName
    principalType: 'ServicePrincipal'
    principalId: frontend.identity.principalId
    roleId: storageDateContributorRoleId
  }
}

module storageAssignmentUser 'Role.bicep' = if (!empty(identity)) {
  name: 'storageAssignmentUser'
  params: {
    baseName: baseName
    principalType: 'User'
    principalId: identity
    roleId: storageDateContributorRoleId
  }
}
