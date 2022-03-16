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

# need to be able to look up the subnet's CIDR
data "oci_core_subnet" "backend_sn" {
  subnet_id = var.subnet_ocid
}

resource "oci_file_storage_file_system" "databasefs" {
  availability_domain = data.oci_identity_availability_domains.local_ads.availability_domains.0.name
  compartment_id      = var.compartment_ocid
  display_name        = "database file system"
}

resource "oci_file_storage_mount_target" "database_mount_tgt" {
  availability_domain = data.oci_identity_availability_domains.local_ads.availability_domains.0.name
  compartment_id      = var.compartment_ocid
  defined_tags        = var.database_defined_tags

  display_name = "database mount target"

  hostname_label = "fss"
  subnet_id      = data.oci_core_subnet.backend_sn.id
}

resource "oci_file_storage_export_set" "database_export_set" {
  mount_target_id = oci_file_storage_mount_target.database_mount_tgt.id
  display_name    = "database storage export set"
}

resource "oci_file_storage_export" "database_export" {
  export_options {
    access                         = "READ_WRITE"
    anonymous_gid                  = "65534"
    anonymous_uid                  = "65534"
    identity_squash                = "NONE"
    require_privileged_source_port = "false"
    source                         = data.oci_core_subnet.backend_sn.cidr_block
  }

  export_set_id  = oci_file_storage_export_set.database_export_set.id
  file_system_id = oci_file_storage_file_system.databasefs.id
  path           = "/db"
}