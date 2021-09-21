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
# Variables specific to the networking module
#

# --------------------------------------------------------------------- global

variable "network_defined_tags" {
  description = "the default tags to be associated with resource"
  type        = map(string)  
  default     = {}
}

# --------------------------------------------------------------------- VCN
variable "vcn_cidr_block" {
  type = string
  description = "the CIDR block to be used with the VCN"
}

variable "vcn_display_name" {
  type = string
  description = "the network's display name as it will appear in the GUI"
}

variable "vcn_dns_label" {
  type = string
  description = "the DNS label to be use"
}


# --------------------------------------------------------------------- subnets

variable "backend_sn_cidr_range" {
  type = string
  description = "VCN range: backend subnet"
}

variable "controlhost_ip_addr" {
  description = "your local laptop's IP addres"
}

# --------------------------------------------------------------------- compartment

variable "compartment_ocid" {
    type = string
    description = "the compartment to use when creating these resources"
}