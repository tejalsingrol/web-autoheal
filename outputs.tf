output "lb_public_ip" {
  value = module.lb.lb_public_ip
}

output "vmss_name" {
  value = module.vmss.vmss_name
}

output "subnet_id" {
  value = module.network.subnet_id
}