import json
import sys

example = """
{
    "StackResourceSummaries": [
        {
            "LogicalResourceId": "ApiCWLRoleArn",
            "PhysicalResourceId": "sam-ap-ApiCW-uHU9j2L28oq1",
            "ResourceType": "AWS::ApiGateway::Account",
            "LastUpdatedTimestamp": "2024-07-28T15:41:59.344000+00:00",
            "ResourceStatus": "CREATE_COMPLETE",
            "DriftInformation": {
                "StackResourceDriftStatus": "IN_SYNC"
            }
        }
    ]

}

"""
### with S: 'loads'
#description = json.loads(example)

### no S: 'load'
description = json.load(sys.stdin)
for resource in description['StackResourceSummaries']:
    if 'LogicalResourceId' in resource and 'PhysicalResourceId' in resource:
      logicalId = resource['LogicalResourceId']
      physicalId = resource['PhysicalResourceId']
      print(f"{logicalId} --> {physicalId}")
      directoryname=sys.argv[1]
      f = open(f"{directoryname}/{logicalId}.txt", "w")
      f.write(physicalId)
      f.close()
