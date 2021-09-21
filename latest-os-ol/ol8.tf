# this is the data source for Oracle Linux 7 images
data "oci_core_images" "ol8_latest" {
        compartment_id = var.compartment_ocid

        operating_system = "Oracle Linux"
        shape = "VM.Standard.E2.1.Micro"
}

# now let's print the OCID
output "latest_ol8_image" {
        value = data.oci_core_images.ol8_latest.images.0.id
} 
