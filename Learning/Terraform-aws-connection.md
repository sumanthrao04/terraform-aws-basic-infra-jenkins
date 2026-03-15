### Local Terraform to AWS connection
To make `terraform plan` work for AWS, you need to give Terraform a valid way to authenticate to AWS. The most common local setup is to configure AWS credentials through the AWS CLI, which stores them in the shared AWS config and credentials files that tools like Terraform can use. Those files are typically `~/.aws/credentials` and `~/.aws/config`, and their locations can also be overridden with environment variables. ([AWS Documentation][1])

### Easiest way for local Terraform projects

Install and configure the AWS CLI, then run:

```bash
aws configure
```

This command writes your access key and secret key to the shared credentials file and writes settings like the default region to the config file. ([AWS Documentation][2])

You’ll be prompted for:

```bash
AWS Access Key ID
AWS Secret Access Key
Default region name
Default output format
```

Example:

```bash
aws configure
```

Then enter values like:

```bash
AWS Access Key ID [None]: AKIA...
AWS Secret Access Key [None]: xxxxx
Default region name [None]: us-east-1
Default output format [None]: json
```

After that, Terraform can usually use those credentials automatically through the AWS provider’s normal authentication flow. AWS documents the shared config and credentials files as the standard place used by AWS SDKs and tools, and HashiCorp documents provider authentication as part of provider configuration. ([AWS Documentation][3])

### Your Terraform provider block

In your Terraform project, keep the AWS provider simple:

```hcl
provider "aws" {
  region = "ap-south-1"
}
```

That sets the region in Terraform. The credentials can come from your AWS CLI profile or environment variables. HashiCorp recommends configuring and authenticating providers separately from the Terraform code where possible. ([HashiCorp Developer][4])

### Alternative: environment variables

You can also set credentials directly as environment variables instead of using `aws configure`:

```bash
export AWS_ACCESS_KEY_ID="your_access_key"
export AWS_SECRET_ACCESS_KEY="your_secret_key"
export AWS_DEFAULT_REGION="ap-south-1"
```

If you are using temporary credentials, also set:

```bash
export AWS_SESSION_TOKEN="your_session_token"
```

AWS documents environment variables and the shared credentials file as supported configuration methods for AWS tools and SDKs. ([AWS Documentation][5])

### Using named profiles

If you want a separate profile for Terraform, create one:

```bash
aws configure --profile terraform-user
```

Then either export the profile before running Terraform:

```bash
export AWS_PROFILE="terraform-user"
terraform plan
```

Or configure the profile in your provider:

```hcl
provider "aws" {
  region  = "ap-south-1"
  profile = "terraform-user"
}
```

AWS shared config files support multiple named profiles. ([AWS Documentation][3])

### How to verify before running Terraform

Run this first:

```bash
aws sts get-caller-identity

output

{
    "UserId": "",
    "Account": "",
    "Arn": ""
}
```

If that succeeds, your credentials are working. Then run:

```bash
terraform init
terraform plan
```

The AWS CLI authentication docs explain that configured credentials determine what actions you can perform against AWS services. ([AWS Documentation][5])

### Best practice

For learning projects, `aws configure` is fine. For better security, AWS guidance recommends using IAM roles and temporary credentials instead of long-lived IAM user access keys whenever possible. AWS also recommends IAM Identity Center or other federated access instead of permanent user keys for many setups. ([AWS Documentation][6])

### Common issue

If you see errors like:

* `No valid credential sources found`
* `error configuring Terraform AWS Provider`
* `AuthFailure`

usually one of these is wrong:

* access key / secret key
* region
* selected AWS profile
* expired temporary credentials
* missing `AWS_SESSION_TOKEN` for temporary creds

### Practical setup for your project

For a basic project like `terraform-aws-basic-infra-jenkins`, a clean local setup is:

1. Install AWS CLI
2. Run `aws configure`
3. Set your Terraform provider region
4. Test with `aws sts get-caller-identity`
5. Run `terraform init` and `terraform plan`

If you want, I’ll give you a complete beginner-friendly setup for this repo with:

* IAM user/role permissions
* provider.tf
* versions.tf
* backend.tf
* `.gitignore`
* Jenkins credential setup

[1]: https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html?utm_source=chatgpt.com "Configuration and credential file settings in the AWS CLI"
[2]: https://docs.aws.amazon.com/cli/latest/reference/configure/?utm_source=chatgpt.com "configure — AWS CLI 2.34.8 Command Reference"
[3]: https://docs.aws.amazon.com/sdkref/latest/guide/file-format.html?utm_source=chatgpt.com "Using shared config and credentials files to globally configure AWS ..."
[4]: https://developer.hashicorp.com/terraform/tutorials/configuration-language/configure-providers?utm_source=chatgpt.com "Configure Terraform providers - HashiCorp Developer"
[5]: https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-authentication.html?utm_source=chatgpt.com "Authentication and access credentials for the AWS CLI"
[6]: https://docs.aws.amazon.com/prescriptive-guidance/latest/terraform-aws-provider-best-practices/security.html?utm_source=chatgpt.com "Security best practices - AWS Prescriptive Guidance"
