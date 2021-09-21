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
# the VCN resource
#

resource "oci_core_vcn" "vcn" {
    
  compartment_id = var.compartment_ocid
  cidr_block     = var.vcn_cidr_block
  defined_tags   = var.network_defined_tags
  display_name   = var.vcn_display_name
  dns_label      = var.vcn_dns_label

}

#
# A subnet for the backend tier
#

resource "oci_core_subnet" "backend_subnet" {

  cidr_block                 = var.backend_sn_cidr_range
  compartment_id             = var.compartment_ocid
  vcn_id                     = oci_core_vcn.vcn.id
  defined_tags               = var.network_defined_tags
  display_name               = "backend subnet"
  dns_label                  = "backend"
  prohibit_public_ip_on_vnic = true
  prohibit_internet_ingress  = true
  security_list_ids          = [
    oci_core_security_list.backend_sl.id
  ]
  route_table_id             = oci_core_route_table.backend_rt.id
}


#
# Default security list allows SSH only (Bastion service doesn't seem to like NSGs)
#

resource "oci_core_security_list" "backend_sl" {

  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.vcn.id

  defined_tags   = var.network_defined_tags
  display_name   = "backend default security list"

  egress_security_rules {

    destination = var.backend_sn_cidr_range
    protocol = "6"

    description = "SSH outgoing"
    destination_type = ""

    stateless = false
    tcp_options {

      max = 22
      min = 22
      
    }
  }

  egress_security_rules {

    destination = "0.0.0.0/0"
    protocol = "6"

    description = "system updates (http)"
    destination_type = ""

    stateless = false
    tcp_options {

      max = 80
      min = 80
      
    }
  }

  egress_security_rules {

    destination = "0.0.0.0/0"
    protocol = "6"

    description = "system updates (https)"
    destination_type = ""

    stateless = false
    tcp_options {

      max = 443
      min = 443
      
    }
  }

  egress_security_rules {

    destination = var.backend_sn_cidr_range
    protocol = "6"

    description = "FSS outbound TCP port 111"
    destination_type = ""

    stateless = false
    tcp_options {

      max = 111
      min = 111
      
    }
  }

  egress_security_rules {

    destination = var.backend_sn_cidr_range
    protocol = "6"

    description = "FSS outbound TCP ports 2048-2050"
    destination_type = ""

    stateless = false
    tcp_options {

      max = 2050
      min = 2048
      
    }
  }

  egress_security_rules {

    destination = var.backend_sn_cidr_range
    protocol = "17"

    description = "FSS outbound UDP port 111"
    destination_type = ""

    stateless = false
    udp_options {

      max = 111
      min = 111
      
    }
  }

  ingress_security_rules {

    protocol = "6"
    source = var.backend_sn_cidr_range

    description = "SSH inbound"
    
    source_type = "CIDR_BLOCK"
    tcp_options {

      max = 22
      min = 22
      
    }
    
  }

  ingress_security_rules {

    protocol = "6"
    source = var.backend_sn_cidr_range

    description = "FSS inbound TCP port 111"
    
    source_type = "CIDR_BLOCK"
    tcp_options {
      max = 111
      min = 111      
    }
  }

  ingress_security_rules {

    protocol = "6"
    source = var.backend_sn_cidr_range

    description = "FSS inbound TCP port 2048+"
    
    source_type = "CIDR_BLOCK"
    tcp_options {
      max = 2050
      min = 2048
    }
  }

  ingress_security_rules {

    protocol = "17"
    source = var.backend_sn_cidr_range

    description = "FSS inbound UDP port 111"
    
    source_type = "CIDR_BLOCK"
    udp_options {
      max = 111
      min = 111     
    }
  }

  ingress_security_rules {

    protocol = "17"
    source = var.backend_sn_cidr_range

    description = "FSS inbound UDP port 2048"
    
    source_type = "CIDR_BLOCK"
    udp_options {
      max = 2048
      min = 2048    
    }
  }

}

#
# A NAT gateway and its route table
#

resource "oci_core_nat_gateway" "ngw" {

  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.vcn.id
  defined_tags   = var.network_defined_tags
  display_name   = "NAT Gateway"
}

resource "oci_core_route_table" "backend_rt" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "backend sub route table"
  defined_tags   = var.network_defined_tags

  route_rules {
    description       = "allow system updates (not recommended)"
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

#
# A Service Gateway for the Bastion Host
#

data "oci_core_services" "sgw_services" {

}

resource "oci_core_service_gateway" "sgw" {

  compartment_id = var.compartment_ocid
  services {

    # service 0 -> all services ...
    service_id = data.oci_core_services.sgw_services.services.0.id
  }

  vcn_id = oci_core_vcn.vcn.id
  
  defined_tags = var.network_defined_tags
  display_name = "SGW for Bastion Service"
}
