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

variable "region" {
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

# --------------------------------------------------------------------- bastion

variable "ssh_vm_key" {
  type        = string
  description = "the (public) SSH key to be used on the VN"
}

variable "ssh_bastion_key" {
  type        = string
  description = "the (public) SSH key to be used with the bastion session"
}

# --------------------------------------------------------------------- network

variable "compute_defined_tags" {
  description = "the default tags to be associated with resource"
  type        = map(string)
  default = {
    "project_tag_namespace.environment_tag" = "bastion-demo"
  }
}

variable "private_sn_cidr_block" {
  type        = string
  description = "CIDR block for the private subnet"
  default     = "10.0.2.0/24"
}

variable "local_laptop_id" {
  description = "CIDR of the control host (your laptop)"
  type        = string
}

