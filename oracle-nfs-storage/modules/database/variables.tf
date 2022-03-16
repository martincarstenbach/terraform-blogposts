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
# Variables specific to the database module
#

# --------------------------------------------------------------------- global

variable "subnet_ocid" {
  type        = string
  description = "the backend subnet's OCID"
}

variable "compartment_ocid" {
  type        = string
  description = "the compartment to use when creating these resources"
}

# --------------------------------------------------------------------- database

variable "instance_shape" {
  type        = string
  description = "the database server's VM's shape"
  default     = "VM.Standard.E2.1"
}

variable "ssh_public_key" {
  type        = string
  description = "The SSH key to be copied to the opc user's account on the database host"
  sensitive   = true
}

variable "database_defined_tags" {
  description = "the default tags to be associated with resource"
  type        = map(string)
  default     = {}
}

# --------------------------------------------------------------------- compartment

