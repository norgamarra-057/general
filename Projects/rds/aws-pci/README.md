Executing aws or terragrunt commands:
-----------
Run the aws command(s) from your laptop or a GDS EC2 instance by using the “Command line or programmatic access” from the PCI SSO page. Just copy the contents of “Option 1: Set AWS environment variables” (AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_SESSION_TOKEN)) and run terragrunt or aws directly.  Remeber the AWS_SESSION_TOKEN expires after 15 minutes.

aws-okta cannot be used.  aws-okta exec proc -- terragrunt plan, for example, will run against the non-PCI account.
