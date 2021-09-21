# Oracle Database on NFS Storage

This folder contains the Terraform code needed to spin up infrastructure for an Oracle database server as well as an [NFS File Storage](https://docs.oracle.com/en-us/iaas/Content/File/Concepts/filestorageoverview.htm).

Access to the database server will be facilitated via a bastion service.

# Usage Notes/Warning

If you `terraform apply` the code, you will incur cost! As with every cloud project, ensure you are authorised to spend the budget. You should also follow cloud best practices and shut down unused resources and/or remove them when no longer needed.

The Terraform code in this folder has been written with the aim of providing an easy-enough to follow example. Some shortcuts have been taken with regards to the IAM requirements as well as error checking. The Terraform code can't be considered production-ready.

# Directory structure

Following the advice from the excellent [Terraform Up and Running](https://www.terraformupandrunning.com/) book this project is laid out as follows:

- A `modules` folder contains
    - definition of the database server + storage
    - the Virtual Cloud Network
- A folder per environment. To keep it simple there is only 1 for the testing environment

## Modules

The use of modules allows me to create abstraction layers. Since the database and network both make most sense when created as atomic units and coherent (eg identically between environment) I decided to create them as modules. The bastion service is too simple to justify creating a module for it.

### Network

The network must be instantiated first. Using output variables data is shared with the database module as well as the bation service. The network module creates a VPC, a subnet and a security list. Sadly, at the time of writing (210921) Network Security Groups didn't work with the bastion service so I resoted to Security Lists.

### Database

The database VM as well as storage are joinlty created. The important bit here is the agent configuration on the database VM: it is set to allow the bastion host to establish a fully managed SSH session. This didn't work with Oracle Linux 8, which is why Oracle Linux 7.9 has been chosen. 

## Testing environment

This folder contains all the code needed for creating the test environment. In particular, the implementation of the network and database modules can be found in here as well as the definition of the [bastion service](https://docs.oracle.com/en-us/iaas/Content/Bastion/Concepts/bastionoverview.htm).

# Further information

Further information can be found in each folder's readme.md