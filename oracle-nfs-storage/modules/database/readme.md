# Database Module

Encapsulation of [database VM](https://docs.oracle.com/en-us/iaas/Content/Compute/Concepts/computeoverview.htm) and [File System Storage](https://docs.oracle.com/en-us/iaas/Content/File/Concepts/filestorageoverview.htm#Overview_of_File_Storage) for hosting an Oracle 19c database. By its nature the code will provision virtual infrastructure, it does not concern itself with configuring it.

Relies on the network module to create the appropriate infrastructure (see input parameters below)

## Database VM

The Terraform code creates the most basic VM possible using Oracle Linux 7.9 as the operating system. At the time of writing the cloud agent struggled to start, with a knock-on effect on not being able to start a fully managed SSH session in via the Bastion service.

## File Storage 

Storage for the database is provisioned via an FSS mount in the same (backend) subnet as the database VM. This should make it easier to design firewall policies as well as the necessary settings to the Security List.

After the FSS infrastructure has been created the actual mount operation must be performed via Ansible or similar.

# Usage

Instantiating the resources in this module will cost you money - don't do it unless you are authorised to do so and understand the implications.

## Input Parameters

The module expects the following input parameters:

| Variable | Description |
| --- | --- |
| ssh_public_key | The SSH key to be deployed for the `opc` user |
| subnet_ocid | the OCID for the backend subnet (will be provided via remote state lookup from the network module ) |
| instance_shape | The instance shape to be used for the database VM. Flexible shapes are not supported at the moment |
| compartment_ocid | the compartment this database should be created in. Should be identical for network/database and bastion |
| database_defined_tags | tags to be attached such as the environment name etc |

## Output Parameters

The database module exports it's OCID via an output variable in `output.tf`

## Futher reading

see ../../testing/database/ for an implementation of the module.