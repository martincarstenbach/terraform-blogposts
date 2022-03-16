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

# --------------------------------------------------------------------- provider

variable "oci_region" {
  description = "necessary parameter for the OCI Terraform provider"
  type        = string
}

variable "private_key_path" {
  description = "necessary parameter for the OCI Terraform provider"
  type        = string
}

variable "key_fingerprint" {
  description = "necessary parameter for the OCI Terraform provider"
  type        = string
}

variable "private_key_password" {
  description = "necessary parameter for the OCI Terraform provider"
  type        = string
}

variable "user_ocid" {
  description = "necessary parameter for the OCI Terraform provider"
  type        = string
}

variable "tenancy_ocid" {
  description = "necessary parameter for the OCI Terraform provider"
  type        = string
}

variable "compartment_ocid" {
  description = "necessary parameter for the OCI Terraform provider"
  type        = string
}

# --------------------------------------------------------------------- Vault Secret

variable "secret_ocid" {
  description = "the OCID pertaining to the OCI Vault Secret to be used"
  type        = string
}

# --------------------------------------------------------------------- ACL allowed IPs

variable "allowed_ip_addresses" {
  description = "this value is passed to whitelisted_ips"
  type        = list(string)
}