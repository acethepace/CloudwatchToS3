# CloudwatchToS3
Terraform module to automate backup of cloudwatch logs to S3

# Steps to use

### Register AWS credentials
* ``aws configure``: enter the credentials which will provide terraform access to the AWS account


### Run the terraform code
* ``terraform init`` : Initialize the terraform providers for AWS
* ``terraform fmt`` : Format the code based on terraform guidelines
* ``terraform validate`` : Validate the existing (and new code)
* ``terraform apply`` : See the expected changes and type "yes" to apply
* ``terraform destroy`` : Remove all created artifacts
