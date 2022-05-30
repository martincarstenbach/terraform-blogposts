# Secret Management via OCI Vault

A small, and at the same time the most basic example on how to use Secrets stored in [OCI VAult](https://docs.oracle.com/en-us/iaas/Content/KeyManagement/Concepts/keyoverview.htm) in Terraform scripts.
See https://martincarstenbach.wordpress.com for more details about this code snippet and the corresponding article.

## Cost Implications

> As with the majority of code snippets in this repository the resources created _are not_ part of the free tier. Executing this code will cost money. Before running this code ensure you are permitted to spend the money

## About this snippet

Secrets Management is a complex topic, this Terraform snippet shows how you can use OCI Vault to securely store and use passwords. Most importantly you never have to work with the actual passwords in the scripts, they are fetched from the Vault and used in the Terraform code.
This post is written with the intention to complement the excellent article [A comprehensive guide to managing secrets in your Terraform code](https://blog.gruntwork.io/a-comprehensive-guide-to-managing-secrets-in-your-terraform-code-1d586955ace1) by Yevgeniy Brikman.

Rather than elaborting how to create a Vault using the OCI  Terraform provider, the snippet assumes the Secret has been created and its Oracle Cloud Identifier (OCID) is known. The OCID is passed to the script via an environment variable, like so:

```shell
$ export TF_VAR_secret_ocid="ocid1.vaultsecret..."
```

An [Autonomous Database](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/database_autonomous_database) is the only resource created in `main.tf`. It's a suitable example as it allows me to provide the ADMIN password via the Vault. Best of all, an ADB instance doesn't require any further supporting infrastructure such as Virtual Cloud Networks (VCNs). The ADB instance created is a free-tier 21c instance.

The code was initially tested with Terraform 1.1.4 and `registry.terraform.io/hashicorp/oci v4.67.0`

To add another layer of security, access to the ADB instance is restricted to certain IP addresses.  You can provide a list of allowed IPs like so:

```bash
$ export TF_VAR_allowed_ip_addresses='[ "1.2.3.4", "4.5.6.7" ]'
```

## Security Implications of using a local backend

To keep things simple, this project uses a local backend to store the Terraform state file. Using a local backend for Terraform state is a security issue for most users since the ADB's instance's password is stored in clear text in the state file. 
See https://www.terraform.io/language/state/sensitive-data for more details about Terraform storing sensitive data in the state file, and https://www.terraform.io/language/settings/backends for details about backends and alternative solutions to the local backend. 

> Please use a backend supporting encryption, approved by your IT security team