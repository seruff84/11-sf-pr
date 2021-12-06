resource "local_file" "ansible_inventory" {
content = templatefile("inventory.tmpl",
  {
    vm = yandex_compute_instance.vm
  }
)
filename = "../ansible/inventory"
provisioner "local-exec" {
 command = "cd ../ansible && ansible-playbook ./playbook11.yml"
 }
}
output "external_ip_addresses" {
  value = toset([
    for vm in yandex_compute_instance.vm : join("=", [vm.name, vm.network_interface[0].nat_ip_address, vm.labels.ansible-group ])
  ])
}