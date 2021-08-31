resource cluster 'Microsoft.ContainerService/managedClusters@2020-09-01' = {
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
      dnsPrefix: 'myaks'
      agentPoolProfiles: [
        {
          name: 'agentpool'
          osDiskSizeGB: 30
          count: 1
          vmSize: 'Standard_D2s_v3'
          osType: 'Linux'
          mode: 'System'
        }
      ]
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

resource registry 'Microsoft.ContainerRegistry/registries@2021-06-01-preview' = {
  sku: {
    name: 'Standard'
  }
  properties: {
    adminUserEnabled: true // ACR Managed Identity Support in WebApps
  }
}

resource frontendapp 'Boop/dotnetapp@v1' = {
  project: 'WebApp/dotnet-web.csproj'
  deployTo: cluster
  uses: [
    { 
      'service': storageacc
      'role': 'Storage Blob Data Contributor'
    }
    {
      'service': serviceBus
      'role': 'Azure Service Bus Data Sender'
    }
  ]
}

resource ingress 'Boop/ingress@v1' = {
  endpoints: [
    {
      path: '/'
      app: frontendapp
    }
  ]
}
