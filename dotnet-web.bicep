@app('WebApp/dotnet-web.csproj')
@uses(storageacc, 'Storage Blob Data Contributor')
@uses(serviceBus, 'Azure Service Bus Data Sender')
resource frontend 'Microsoft.Web/sites@2021-01-15' = {
  properties: {
    serverFarmId: appService.id
  }
}

@app('FunctionApp/FunctionApp.csproj')
@uses(serviceBus, 'Azure Service Bus Data Receiver')
resource workerFunction 'Microsoft.Web/sites@2021-01-15' = {
  properties: {
    serverFarmId: appService.id
  }
  kind: 'functionapp'
}

resource appService 'Microsoft.Web/serverFarms@2020-06-01' = {
  sku: {
    name: 'F1'
  }
}

resource storageacc 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  kind:'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
}

resource serviceBus 'Microsoft.ServiceBus/namespaces@2021-01-01-preview' = {
  resource ns 'queues' = {
    name: 'Items'
  }
}
