@description('The name of the EventHub namespace')
param eventHubNamespaceName string = 'ft1hubns${uniqueString(resourceGroup().id)}'

@description('The name of the EventHub')
param eventHubName string = 'ft1EventHub'

@description('EventHub Sku')
param eventHubSku string = 'Standard'

@description('EventHub Tier')
param eventHubTier string = 'Standard'

@description('EventHub capacity')
param eventHubCapacity int = 1

@description('The location of the Azure Data Explorer cluster')
param location string = resourceGroup().location

@description('The name of the Azure Data Explorer Event Hub consumer group')
param eventHubConsumerGroupName string = 'ft1ConsumerGroup'

@description('The name of the Azure Data Explorer Event Hub production line consumer group')
param eventHubConsumerGroupNamePl string = 'ft1ConsumerGroupPl'

resource eventHubNamespace 'Microsoft.EventHub/namespaces@2023-01-01-preview' = {
  name: eventHubNamespaceName
  location: location
  sku: {
    name: eventHubSku
    capacity: eventHubCapacity
    tier: eventHubTier
  }
}

resource eventHub 'Microsoft.EventHub/namespaces/eventhubs@2023-01-01-preview' = {
  name: eventHubName
  parent: eventHubNamespace
  properties: {
    messageRetentionInDays: 1
  }
}

resource eventHubAuthRule 'Microsoft.EventHub/namespaces/authorizationRules@2023-01-01-preview' = {
  name: 'eventHubAuthRule'
  parent: eventHubNamespace
  properties: {
    rights: [
      'Listen'
    ]
  }
}

resource eventHubConsumerGroup 'Microsoft.EventHub/namespaces/eventhubs/consumergroups@2023-01-01-preview' = {
  name: eventHubConsumerGroupName
  parent: eventHub
}

resource eventHubConsumerGroupPl 'Microsoft.EventHub/namespaces/eventhubs/consumergroups@2023-01-01-preview' = {
  name: eventHubConsumerGroupNamePl
  parent: eventHub
}


output eventHubResourceId string = eventHub.id
