variable "yc_token" {}
variable "yc_cloud_id" {}
variable "yc_zone" {}
variable "yc_folder_id" {}
variable "ssh_pub_ansible" {}
variable "ssh_pub_user" {}
variable "vms" {
    type = map(object({
        hostname    = string
        role        = string
        os_family   = string
        vm_cores	= string
        vm_memory	= string
        vm_disk     = string
    }))
}