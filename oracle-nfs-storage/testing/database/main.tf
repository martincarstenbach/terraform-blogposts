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
# Definition of the OCI Provider: testing environment - database
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
# looking up network properties from the network module
#
data "terraform_remote_state" "network" {
  backend = "local"
  config = {
    path = "../network/terraform.tfstate"
  }
}

#
# referencing the database module
#

module "database_module" {
  source = "../../modules/database"

  # module variables
  ssh_public_key = var.ssh_vm_key
  subnet_ocid    = data.terraform_remote_state.network.outputs.database_subnet_ocid
  instance_shape = "VM.Standard.E2.4"

  compartment_ocid = var.compartment_ocid

  # define tags as per global/namespaces
  database_defined_tags = {
    "project_tag_namespace.environment_tag" : "testing"
  }
}
