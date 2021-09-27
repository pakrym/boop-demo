resource frontendapp 'Boop/nodejsapp@v1' ={
  project: 'app/package.json'
  deployTo: frontend
  uses: [
    {
      service: storageacc
      role: 'Storage Blob Data Contributor'
    }
  ]
}

resource frontend 'Microsoft.Web/sites@2021-01-15' = {
  kind: 'app,linux'
  properties: {
    serverFarmId: appService.id
    siteConfig: {
      linuxFxVersion: 'NODE|14-lts'
    }
  }
}

resource appService 'Microsoft.Web/serverFarms@2020-06-01' = {
  kind: 'linux'
  sku: {
    name: 'B1'
  }
  properties: {
    reserved: true
  }
}

resource storageacc 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
}
