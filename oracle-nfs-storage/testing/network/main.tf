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
# Definition of the OCI Provider: testing environment - network
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
# referencing the networking module
#

module "networking_module" {
  source = "../../modules/networking"

  # module variables
  vcn_cidr_block        = "10.0.0.0/16"
  vcn_display_name      = "testing VCN"
  vcn_dns_label         = "tst"
  backend_sn_cidr_range     = "10.0.1.0/24"
  controlhost_ip_addr   = "1.2.3.4/32"

  compartment_ocid = var.compartment_ocid
  
  # define tags as per global/namespaces
  network_defined_tags = {
    "project_tag_namespace.environment_tag": "testing"
  }
}

