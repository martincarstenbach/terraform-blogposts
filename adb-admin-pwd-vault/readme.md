# Secret Management via OCI Vault

A small, and at the same time the most basic example on how to use Secrets stored in [OCI VAult](https://docs.oracle.com/en-us/iaas/Content/KeyManagement/Concepts/keyoverview.htm) in Terraform scripts to avoid posting credentials to code repositories by accident.

See https://martincarstenbach.wordpress.com for more details about this code snippet

## Cost Implications

> As with the majority of code snippets in this repository the resources created _are not_ part of the free tier. Executing this code will cost money. Before running this code ensure you are permitted to spend the money

## About this snippet

Secrets Management is a complex topic, this Terraform snippet shows how you can use OCI Vault to securely store passwords. Most importantly you never have to work with the actual passwords in the scripts, they are fetched from the Vault and used in the Terraform code.

This post is written with the intention to complement the excellent article [A comprehensive guide to managing secrets in your Terraform code](https://blog.gruntwork.io/a-comprehensive-guide-to-managing-secrets-in-your-terraform-code-1d586955ace1) by Yevgeniy Brikman.

Rather than adding how to create a Vault using the OCI  Terraform provider, the snippet assumes the Secret has been created and its Oracle Cloud Identifier (OCID) is known. The OCID is passed to the script via an environment variable.

An [Autonomous Database](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/database_autonomous_database) is the only resource created in `main.tf`. It's a suitable example as it allows me to provide the ADMIN password via the Vault. Best of all an ADB instance doesn't require any further supporting infrastructure such as Virtual Cloud Networks (VCNs). The ADB instance created is a free-tier 21c instance.

The code was tested with Terraform 1.1.4 and registry.terraform.io/hashicorp/oci v4.67.0

You can provide a list of allowed IPs like so:

```bash
$ export TF_VAR_allowed_ip_addresses='[ "1.2.3.4", "4.5.6.7" ]'
$ terraform plan -out myplan
```

See https://www.terraform.io/language/values/variables for more details