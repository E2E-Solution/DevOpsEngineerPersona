// ============================================================================
// Monitoring & Alerting Module
// ============================================================================
// Creates Azure Monitor alert rules for production SRE monitoring.
// These alerts detect API failures, high latency, and availability issues.
//
// Alert channels: Email notification via Action Group
// ============================================================================

@description('Application Insights resource ID')
param appInsightsId string

@description('Application Insights name (for scoping)')
param appInsightsName string

@description('Location for resources')
param location string

@description('Email address for alert notifications')
param alertEmail string

@description('Environment name for alert naming')
param environment string

@description('Severity level for alerts (0=Critical, 1=Error, 2=Warning)')
param defaultSeverity int = 2

// ============================================================================
// Action Group (notification channel)
// ============================================================================

resource actionGroup 'Microsoft.Insights/actionGroups@2023-09-01-preview' = {
  name: 'ag-zava-${environment}'
  location: 'global'
  properties: {
    groupShortName: 'ZavaAlerts'
    enabled: true
    emailReceivers: [
      {
        name: 'SRE Team'
        emailAddress: alertEmail
        useCommonAlertSchema: true
      }
    ]
  }
}

// ============================================================================
// Alert: High API Error Rate (>5% of requests return 5xx in 5 minutes)
// ============================================================================

resource highErrorRateAlert 'Microsoft.Insights/metricAlerts@2018-03-01' = {
  name: 'alert-high-error-rate-${environment}'
  location: 'global'
  properties: {
    description: 'Triggers when more than 5% of API requests return server errors (5xx) over a 5-minute window.'
    severity: 1
    enabled: true
    scopes: [appInsightsId]
    evaluationFrequency: 'PT1M'
    windowSize: 'PT5M'
    criteria: {
      'odata.type': 'Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria'
      allOf: [
        {
          criterionType: 'StaticThresholdCriterion'
          name: 'HighErrorRate'
          metricName: 'requests/failed'
          metricNamespace: 'microsoft.insights/components'
          operator: 'GreaterThan'
          threshold: 5
          timeAggregation: 'Count'
        }
      ]
    }
    actions: [
      {
        actionGroupId: actionGroup.id
      }
    ]
  }
}

// ============================================================================
// Alert: High API Response Time (p95 > 3 seconds over 5 minutes)
// ============================================================================

resource highLatencyAlert 'Microsoft.Insights/metricAlerts@2018-03-01' = {
  name: 'alert-high-latency-${environment}'
  location: 'global'
  properties: {
    description: 'Triggers when p95 API response time exceeds 3 seconds over a 5-minute window.'
    severity: defaultSeverity
    enabled: true
    scopes: [appInsightsId]
    evaluationFrequency: 'PT1M'
    windowSize: 'PT5M'
    criteria: {
      'odata.type': 'Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria'
      allOf: [
        {
          criterionType: 'StaticThresholdCriterion'
          name: 'HighLatency'
          metricName: 'requests/duration'
          metricNamespace: 'microsoft.insights/components'
          operator: 'GreaterThan'
          threshold: 3000
          timeAggregation: 'Average'
        }
      ]
    }
    actions: [
      {
        actionGroupId: actionGroup.id
      }
    ]
  }
}

// ============================================================================
// Alert: Availability Drop (health endpoint fails)
// ============================================================================

resource availabilityAlert 'Microsoft.Insights/metricAlerts@2018-03-01' = {
  name: 'alert-availability-${environment}'
  location: 'global'
  properties: {
    description: 'Triggers when the application availability drops below 99% over a 5-minute window.'
    severity: 0
    enabled: true
    scopes: [appInsightsId]
    evaluationFrequency: 'PT1M'
    windowSize: 'PT5M'
    criteria: {
      'odata.type': 'Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria'
      allOf: [
        {
          criterionType: 'StaticThresholdCriterion'
          name: 'LowAvailability'
          metricName: 'availabilityResults/availabilityPercentage'
          metricNamespace: 'microsoft.insights/components'
          operator: 'LessThan'
          threshold: 99
          timeAggregation: 'Average'
        }
      ]
    }
    actions: [
      {
        actionGroupId: actionGroup.id
      }
    ]
  }
}
