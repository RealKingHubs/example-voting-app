Region: eu-north-1. The AWS Organization uses a service control policy
that blocks other regions, so all resources are built in Stockholm.

IRSA is disabled because the AWS Organization blocks creating IAM OIDC
providers. Nodes use free tier eligible instance types because the account
is on a restricted plan.