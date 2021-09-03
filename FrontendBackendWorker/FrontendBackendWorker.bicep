resource frontendapp 'Boop/dotnetapp@v1' ={
  project: 'WebApp/dotnet-web.csproj'
  deployTo: frontend
  uses: [
    {
      service: storageacc
      role: 'Storage Blob Data Contributor'
    }
    {
      service: serviceBus
      role: 'Azure Service Bus Data Sender'
    }
    {
      service: backend
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

resource serviceBus 'Microsoft.ServiceBus/namespaces@2021-01-01-preview' = {
  resource ns 'queues' = {
    name: 'Items'
  }
}

// FUNCTION APP
resource workerfunction 'Boop/functionapp@v1' ={
  project: 'FunctionApp/FunctionApp.csproj'
  deployTo: workerFunctionSite
  uses: [
    {
      'service': serviceBus
      'role': 'Azure Service Bus Data Receiver'
    }
  ]
}

resource workerFunctionSite 'Microsoft.Web/sites@2021-01-15' = {
  properties: {
    serverFarmId: appService.id
  }
  kind: 'functionapp'
}

// DOCKER BACKEND

resource backendapp 'Boop/dockerapp@v1' ={
  project: 'Backend/Dockerfile'
  deployTo: backend
}

resource backend 'Microsoft.Web/sites@2021-01-15' = {
  kind: 'app,linux'
  properties: {
    serverFarmId: backEndAppService.id
  }
}

resource backEndAppService 'Microsoft.Web/serverFarms@2020-06-01' = {
  sku: {
    name: 'B1'
  }
  properties: {
    reserved: true
  }
}

resource registry 'Microsoft.ContainerRegistry/registries@2021-06-01-preview' = {
  sku: {
    name: 'Standard'
  }
  properties: {
    adminUserEnabled: true // ACR Managed Identity Support in WebApps
  }
}
