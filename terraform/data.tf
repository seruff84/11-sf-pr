data "yandex_compute_image" "my_image" {
  for_each        = var.vms
  family = each.value.os_family
}