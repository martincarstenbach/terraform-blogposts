# Network Module

A small module for creating a [Virtual Cloud Network](https://docs.oracle.com/en-us/iaas/Content/Network/Concepts/overview.htm). It consists primarily of a private subnet to host the database VM and File System Storage. There is no intent to create a public subnet due to security constraints. Access to resources in the private backend subnet is facilitated via a [Bastion service](https://docs.oracle.com/en-us/iaas/Content/Bastion/Concepts/bastionoverview.htm)

Since the Bation Service didn't work as expected when using Network Security Groups (NSGs) a single Security List (SL) is used instead. The main permissions are SSH for use with the Bastion Service, system updates via HTTP and HTTPS (a Bad Idea for real environments but good enough for the lab), as well as those permissions required for NFSv3

# Usage

The module expects the following parameters.

## Input Parameters

| Parameter | Description |
| --- | --- |
| vcn_cidr_block | The CIDR block to be used for the VPC |
| vcn_display_name | A user friendly name assigned to the VPC |
| vcn_dns_label | The DNS label to be used with the VCN |
| backend_sn_cidr_range | the CIDR range to be used for the backend subnet. Must be within `vcn_cidr_block` |
| controlhost_ip_addr | your laptop's public IP address. SSH access will all be locked down expect for the control host's IP address |
| compartment_ocid | the target compartment's OCID. Should be the compartment for network/database/bastion |
| network_defined_tags | defined tasks, such as environment name, cost centre etc |

## Output Parameters

The module exports the private backend subnet OCID