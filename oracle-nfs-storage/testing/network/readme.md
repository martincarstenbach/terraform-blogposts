# Network

This folder contains the code necessary to create a [Virtual Cloud Network](https://docs.oracle.com/en-us/iaas/Content/Network/Concepts/overview.htm). This is the first component that has to be created - without a network, neither database, nor File System Storage nor the Bastion service can be created. 

# Usage

The following sections detail how to create the resources within this folder.

> You will incur cost creating these resources.

## Requirements

The code was written using

- Terraform v1.0.6 on linux_amd64
- provider registry.terraform.io/hashicorp/oci v4.42.0

You need to be authorised to spend money when creating these resources!

## Dependencies

None, this is the first resource to be created.

## Running the code

Source your environment variables (`TF_VAR_variable`) as always to allow the provider to create the resources in your compartment. It is assumed your account has the relevant IAM policies granted to create the resources defined in the code. Note that my API key is password protected as recommended by Oracle. 

Once your environment is set, run `terraform init` before `terraform plan` and eventually `terraform apply`

## Known problems

None, please raise a Github issue if you find one.