# Bastion

This folder contains the definition of the bastion service. Instead of using a bastion host as in other examples, the release of the bastion service makes it possible to significantly reduce complexity in the code. 

Interestingly the bastion service didn't respect Network Security Groups (NSGs) at the time of writing (2021-09-06) which is why a Security List was chosen instead. I also had to downgrade the VM from Oracle Linux 8.4 to 7.9 to avoid issues with the cloud agent I didn't care enough about to verify a deeper investigation.

The bastion service was too basic to justify including into a module. 

# Usage

The following sections detail how to create the resources within this folder.

> You will incur cost creating these resources.

## Requirements

The code was written/tested on:

- Terraform v1.0.6 on linux_amd64
- provider registry.terraform.io/hashicorp/oci v4.42.0

You need to be authorised to spend money when creating these resources!

## Dependencies

The Virtual Cloud Network ( -> network folder) and Database VM (-> ../database) must have been created.

## Running the code

Source your environment variables (`TF_VAR_variable`) as always to allow the provider to create the resources in your compartment. It is assumed your account has the relevant IAM policies granted to create the resources defined in the code. Note that my API key is password protected as recommended by Oracle. 

Once your environment is set, run `terraform init` before `terraform plan` and eventually `terraform apply`

## Known problems

This section lists known problems you might encounter

### Bastion Session not created

```
"code" : 400,
"message" : "To create a Managed SSH session, the Bastion plugin must be in the RUNNING state on the target instance, but the plugin is not running on ocid1.instance..... Enable the Bastion plugin on the target instance before creating the session."
```

... give it a few minutes before creating the bastion session after creating the database. It takes a bit of time for the agent to report its working state.


### Bastion Session expired

The bastion session has an explicit time-to-live assigned (60 minutes). Once these expire, the session expires. Simply run `terraform apply` again to re-create it.