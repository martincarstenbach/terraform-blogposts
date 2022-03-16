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

# --------------------------------------------------------------------- provider

provider "oci" {
  tenancy_ocid         = var.tenancy_ocid
  user_ocid            = var.user_ocid
  fingerprint          = var.key_fingerprint
  private_key_path     = var.private_key_path
  private_key_password = var.private_key_password
  region               = var.oci_region
}

#
# get the database backups for src_db_ocid
#
data "oci_database_backups" "src_bkp" {
  database_id = var.src_db_ocid
}

output "src_bkp_name" {
  value = data.oci_database_backups.src_bkp.backups.0.display_name
}

output "src_bkp_id" {
  value = data.oci_database_backups.src_bkp.backups.0.id
}

#
# A resource to create a new "DEV" database system 
#
resource "oci_database_db_system" "dev_system" {

  # the AD of the new environment has to match the AD where
  # the backup is stored (a property exported by the data source)
  availability_domain = data.oci_database_backups.src_bkp.backups.0.availability_domain

  # instruction to create the database from a backup
  source = "DB_BACKUP"

  # Some of these properties are hard-coded to suit my use case. 
  # Your requirement is almost certainly different. Make sure you
  # change paramaters as required
  compartment_id          = var.compartment_ocid
  database_edition        = "ENTERPRISE_EDITION"
  data_storage_size_in_gb = 256
  hostname                = "dev"
  shape                   = "VM.Standard2.1"
  node_count              = 1
  ssh_public_keys         = [var.ssh_public_key]
  subnet_id               = var.subnet_id
  nsg_ids                 = [var.nsg_id]
  license_model           = "LICENSE_INCLUDED"

  display_name = "development DB system"

  db_home {

    database {
      # the admin password for the _new_ database
      admin_password = var.new_admin_pwd

      # this is from the source backup!
      backup_tde_password = var.backup_tde_password
      backup_id           = data.oci_database_backups.src_bkp.backups.0.id

      db_name = "DEV"
    }

  }

  db_system_options {
    storage_management = "ASM"
  }
}
