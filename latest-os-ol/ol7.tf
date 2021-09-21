# this is the data source for Oracle Linux 7 images
data "oci_core_images" "ol7_latest" {
        compartment_id = var.compartment_ocid

        operating_system = "Oracle Linux"
        operating_system_version = "7.9"
        shape = "VM.Standard.E2.1.Micro"
}

# now let's print the OCID
output "latest_ol7_image" {
        value = data.oci_core_images.ol7_latest.images.0.id
} 
