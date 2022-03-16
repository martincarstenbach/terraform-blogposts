# Copyright 2022 Martin Bach
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# --------------------------------------------------------------------- begin code section

#
# Definition of the OCI Provider
#

provider "oci" {
  tenancy_ocid         = var.tenancy_ocid
  user_ocid            = var.user_ocid
  fingerprint          = var.key_fingerprint
  private_key_path     = var.private_key_path
  private_key_password = var.private_key_password
  region               = var.region
}


#
# creation of the bastion service
#

# --------------------------------------------------------------------- remote state: private subnet ID

data "terraform_remote_state" "network_state" {
  backend = "local"
  config = {
    path = "../network/terraform.tfstate"
  }
}

# --------------------------------------------------------------------- remote state: instance data

data "terraform_remote_state" "compute_state" {
  backend = "local"
  config = {
    path = "../compute/terraform.tfstate"
  }
}

resource "oci_bastion_bastion" "demo_bastionsrv" {

  bastion_type     = "STANDARD"
  compartment_id   = var.compartment_ocid
  target_subnet_id = data.terraform_remote_state.network_state.outputs.private_subnet_id

  client_cidr_block_allow_list = [
    var.local_laptop_id
  ]

  defined_tags = var.network_defined_tags

  name = "demobastionsrv"
}


resource "oci_bastion_session" "demo_bastionsession" {

  bastion_id = oci_bastion_bastion.demo_bastionsrv.id

  key_details {

    public_key_content = var.ssh_bastion_key
  }

  target_resource_details {

    session_type       = "MANAGED_SSH"
    target_resource_id = data.terraform_remote_state.compute_state.outputs.private_instance_id

    target_resource_operating_system_user_name = "opc"
    target_resource_port                       = "22"
  }

  session_ttl_in_seconds = 3600

  display_name = "bastionsession-private-host"
}

output "connection_details" {
  value = oci_bastion_session.demo_bastionsession.ssh_metadata.command
}