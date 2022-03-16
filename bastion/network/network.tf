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
# definition of the private network
#

resource "oci_core_vcn" "vcn" {

  compartment_id = var.compartment_ocid
  cidr_block     = "10.0.2.0/24"
  defined_tags   = var.network_defined_tags
  display_name   = "demovcn"
  dns_label      = "demo"

}

# --------------------------------------------------------------------- subnet

resource "oci_core_subnet" "private_subnet" {

  cidr_block                 = var.private_sn_cidr_block
  compartment_id             = var.compartment_ocid
  vcn_id                     = oci_core_vcn.vcn.id
  defined_tags               = var.network_defined_tags
  display_name               = "private subnet"
  dns_label                  = "private"
  prohibit_public_ip_on_vnic = true
  prohibit_internet_ingress  = true
  route_table_id             = oci_core_route_table.private_rt.id
  security_list_ids = [
    oci_core_security_list.private_sl.id
  ]
}

# --------------------------------------------------------------------- security list

resource "oci_core_security_list" "private_sl" {

  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.vcn.id

  defined_tags = var.network_defined_tags
  display_name = "private subnet more strict security list"

  egress_security_rules {

    destination = "0.0.0.0/0"
    protocol    = "6"

    description      = "system updates (http)"
    destination_type = ""

    stateless = false
    tcp_options {

      max = 80
      min = 80

    }
  }

  egress_security_rules {

    destination = "0.0.0.0/0"
    protocol    = "6"

    description      = "system updates (https)"
    destination_type = ""

    stateless = false
    tcp_options {

      max = 443
      min = 443

    }
  }

  egress_security_rules {

    destination = var.private_sn_cidr_block
    protocol    = "6"

    description      = "SSH outgoing"
    destination_type = ""

    stateless = false
    tcp_options {

      max = 22
      min = 22

    }
  }

  ingress_security_rules {

    protocol = "6"
    source   = var.private_sn_cidr_block

    description = "SSH inbound"

    source_type = "CIDR_BLOCK"
    tcp_options {

      max = 22
      min = 22

    }

  }
}

# --------------------------------------------------------------------- NAT gateway

resource "oci_core_nat_gateway" "ngw" {

  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.vcn.id
  defined_tags   = var.network_defined_tags
  display_name   = "NAT Gateway"
}

# --------------------------------------------------------------------- route table

resource "oci_core_route_table" "private_rt" {

  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "private subnet route table"
  defined_tags   = var.network_defined_tags

  route_rules {

    description       = "allow system updates (acceptable only for this quick demo!)"
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_nat_gateway.ngw.id
  }

  route_rules {

    description       = "Allow access via bastion service"
    destination       = lookup(data.oci_core_services.sgw_services.services.0, "cidr_block")
    destination_type  = "SERVICE_CIDR_BLOCK"
    network_entity_id = oci_core_service_gateway.sgw.id
  }
}

# --------------------------------------------------------------------- service gateway

data "oci_core_services" "sgw_services" {

}

resource "oci_core_service_gateway" "sgw" {

  compartment_id = var.compartment_ocid
  services {

    # service 0 means all services, not just block storage ...
    service_id = data.oci_core_services.sgw_services.services.0.id
  }

  vcn_id = oci_core_vcn.vcn.id

  defined_tags = var.network_defined_tags
  display_name = "SGW for Bastion Service"
}