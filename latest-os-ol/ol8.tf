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

# this is the data source for Oracle Linux 7 images
data "oci_core_images" "ol8_latest" {
  compartment_id = var.compartment_ocid

  operating_system = "Oracle Linux"
  shape            = "VM.Standard.E2.1.Micro"
}

# now let's print the OCID
output "latest_ol8_image" {
  value = data.oci_core_images.ol8_latest.images.0.id
}
