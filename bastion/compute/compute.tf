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


#
# A smal cloud VM
#

# --------------------------------------------------------------------- latest OL8 image

data "oci_core_images" "ol8_latest" {
  compartment_id = var.compartment_ocid

  operating_system = "Oracle Linux"
  shape            = "VM.Standard.E2.1.Micro"
}

# --------------------------------------------------------------------- all availability domains

data "oci_identity_availability_domains" "ads" {
  compartment_id = var.compartment_ocid
}

# --------------------------------------------------------------------- remote state: private subnet ID

data "terraform_remote_state" "network_state" {
  backend = "local"
  config = {
    path = "../network/terraform.tfstate"
  }
}

# --------------------------------------------------------------------- private compute instance

resource "oci_core_instance" "private_instance" {
  agent_config {
    is_management_disabled = false
    is_monitoring_disabled = false

    plugins_config {
      desired_state = "ENABLED"
      name          = "Vulnerability Scanning"
    }

    plugins_config {
      desired_state = "ENABLED"
      name          = "Compute Instance Monitoring"
    }

    plugins_config {
      desired_state = "ENABLED"
      name          = "Bastion"
    }
  }

  defined_tags = var.compute_defined_tags

  create_vnic_details {

    assign_private_dns_record = true
    assign_public_ip          = false
    hostname_label            = "privateinst"
    subnet_id                 = data.terraform_remote_state.network_state.outputs.private_subnet_id
    nsg_ids                   = []
  }

  availability_domain = data.oci_identity_availability_domains.ads.availability_domains.0.name
  compartment_id      = var.compartment_ocid

  display_name = "private instance"

  shape = "VM.Standard.E3.Flex"
  shape_config {
    memory_in_gbs = 32
    ocpus         = 2
  }
  metadata = {
    "ssh_authorized_keys" = var.ssh_vm_key
  }
  source_details {
    source_id   = data.oci_core_images.ol8_latest.images.0.id
    source_type = "image"
  }
}