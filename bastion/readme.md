# Bastion Service Demo

This is a small demo to create a bastion service to access a VM in a private subnet. See https://martincarstenbach.wordpress.com/2021/11/12/create-an-oci-bastion-service-via-terraform/ for more details.

## WARNING

Executing this Terraform code will incur cost! Resources created are not part of the free tier. 

## Contents

The Terraform code in this project isn't well-refined and does not adhere to all best-known methods. It works for my demos, please don't use it for resource supposed to live for more than 45 minutes or more.

The code is split into 3 directories

- Network
- Compute
- Bastion

The netowrk code is the foundatation and creates all the necssary network infrastructure. It exports the private subnet's OCID which in turn is used by the other modules. The code in the compute directory spins up a VM and exports its OCID.

Finally, the code in the bastion directory creates a bastion and a session, linking to the newly created instance.

## Software Versions

The code was tested on Ubuntu 20.04 LTS running `terraform` 1.0.10 and release 4.52.0 of the OCI terraform provider 

## Known Issues

It's entirely possible for the bastion session to run into an error since it takes a few minutes for the the bastion agent to start. It is necessary to wait a couple of minutes after spinning the VM up.

## Feedback

Please let me know if you spot things that can be improved using the usual Github workflows.