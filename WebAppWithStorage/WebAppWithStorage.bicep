resource frontendapp 'Boop/dotnetapp@v1' ={
  project: 'WebApp/dotnet-web.csproj'
  deployTo: frontend
  uses: [
    {
      service: storageacc
      role: 'Storage Blob Data Contributor'
    }
  ]
}

resource frontend 'Microsoft.Web/sites@2021-01-15' = {
  properties: {
    serverFarmId: appService.id
  }
}

resource appService 'Microsoft.Web/serverFarms@2020-06-01' = {
  sku: {
    name: 'F1'
  }
}

resource storageacc 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
}
