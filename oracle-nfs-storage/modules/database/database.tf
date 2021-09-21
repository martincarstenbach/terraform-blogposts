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

# this is the data source for Oracle Linux 7 images
data "oci_core_images" "ol7_latest" {
  compartment_id           = var.compartment_ocid

  operating_system         = "Oracle Linux"
  operating_system_version = "7.9"
  shape                    = var.instance_shape
}

# get a list of all availability domains in the region
data "oci_identity_availability_domains" "local_ads" {
  compartment_id = var.compartment_ocid
}

# Create the database host
resource "oci_core_instance" "database_instance" {

  availability_domain = data.oci_identity_availability_domains.local_ads.availability_domains.0.name
  compartment_id      = var.compartment_ocid
  shape               = var.instance_shape

  create_vnic_details {
    assign_public_ip = false
    hostname_label   = "database"
    subnet_id        = var.subnet_ocid
  }

  agent_config {
    are_all_plugins_disabled  = false
    is_management_disabled    = false
    is_monitoring_disabled    = false
    plugins_config  {
      desired_state = "ENABLED"
      name          = "Bastion"
    }
  }

  display_name = "database host"

  defined_tags = var.database_defined_tags

  metadata = {
    "ssh_authorized_keys" = var.ssh_public_key
  }

  source_details {

    source_id   = data.oci_core_images.ol7_latest.images.0.id
    source_type = "image"

    # database storage will be provided via NFS, this volume will host O/S + RDBMS binaries
    boot_volume_size_in_gbs = 250
  }

  preserve_boot_volume = false
}