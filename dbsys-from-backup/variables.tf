#
# provider specific variables
#
variable "tenancy_ocid" {
  type = string
}

variable "user_ocid" {
  type = string
}

variable "key_fingerprint" {
  type = string
}

variable "private_key_path" {
  type = string
}

variable "private_key_password" {
  type = string
}

variable "oci_region" {
  type = string
}


#
# variables specific to the Terraform script
#
variable "src_db_ocid" {
  type = string
}

variable "compartment_ocid" {
  type = string
}

variable "ssh_public_key" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "nsg_id" {
  type = string
}

variable "new_admin_pwd" {
  type      = string
  sensitive = true
}

variable "backup_tde_password" {
  type      = string
  sensitive = true
}
