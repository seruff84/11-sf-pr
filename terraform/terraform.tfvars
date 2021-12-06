yc_zone       = "ru-central1-a"

vms = {
    vm1 = {
        hostname    = "vm1"
        role        = "elk"
        os_family	= "ubuntu-2004-lts"
        vm_cores	= "2"
        vm_memory	= "8"
        vm_disk     = "100"
    }
    vm2 = {
        hostname    = "vm2"
        role        = "web"
        os_family	= "ubuntu-2004-lts"
        vm_cores	= "2"
        vm_memory	= "4"
        vm_disk     = "30"
    }
}
