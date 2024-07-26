#aws-okta exec prod -- aws rds describe-db-cluster-endpoints --region us-west-1 --filters Name="db-cluster-endpoint-type",Values="writer"
aws rds describe-db-cluster-endpoints --filters Name="db-cluster-endpoint-type",Values="writer"
