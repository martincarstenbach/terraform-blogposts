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
  region               = var.oci_region
}

# --------------------------------------------------------------------- data source used for password lookup

data "oci_secrets_secretbundle" "bundle" {

  secret_id = var.secret_ocid
}

# --------------------------------------------------------------------- Autonomous Database

resource "oci_database_autonomous_database" "test_autonomous_database" {

  compartment_id                                 = var.compartment_ocid
  db_name                                        = "DEMO"
  admin_password                                 = base64decode(data.oci_secrets_secretbundle.bundle.secret_bundle_content.0.content)
  cpu_core_count                                 = 1
  data_storage_size_in_tbs                       = 1
  db_version                                     = "21c"
  db_workload                                    = "OLTP"
  display_name                                   = "ADB Free Tier 21c"
  is_free_tier                                   = true
  is_mtls_connection_required                    = true
  is_preview_version_with_service_terms_accepted = false
  ocpu_count                                     = 1
  whitelisted_ips                                = var.allowed_ip_addresses
}
