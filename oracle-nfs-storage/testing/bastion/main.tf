# Copyright 2021 Martin Bach
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
# Definition of the OCI Provider: testing environment - bastion service
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
# add lookup-data sources
#
data "terraform_remote_state" "network" {
  backend = "local"
  config = {
    path = "../network/terraform.tfstate"
  }
}

data "terraform_remote_state" "database" {
  backend = "local"
  config = {
    path = "../database/terraform.tfstate"
  }
}

#
# definition of the bastion service for the `testing` environment
#

resource "oci_bastion_bastion" "bastionsrv_testing" {

  bastion_type     = "STANDARD"
  compartment_id   = var.compartment_ocid
  target_subnet_id = data.terraform_remote_state.network.outputs.database_subnet_ocid

  client_cidr_block_allow_list = [
    var.local_laptop_id
  ]
  defined_tags = {
    "project_tag_namespace.environment_tag" : "testing"
  }

  name = "testingbastion"
}


resource "oci_bastion_session" "bastionsession_database_host" {

  bastion_id = oci_bastion_bastion.bastionsrv_testing.id
  key_details {

    public_key_content = var.ssh_vm_key
  }
  target_resource_details {

    session_type       = "MANAGED_SSH"
    target_resource_id = data.terraform_remote_state.database.outputs.database_vm_ocid

    target_resource_operating_system_user_name = "opc"
    target_resource_port                       = "22"
  }

  session_ttl_in_seconds = 3600

  display_name = "bastion-session-database-host"
}

