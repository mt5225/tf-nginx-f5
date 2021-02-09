# ref: https://registry.terraform.io/modules/Terraform-VMWare-Modules/vm/vsphere/latest
# Deploy 2 linux VMs
module "server-nginx" {
  source        = "Terraform-VMWare-Modules/vm/vsphere"
  vmtemp        = "VM Template Name (Should Alrerady exist)"
  instances     = 2
  vmname        = "example-server-linux"
  vmrp          = "demo"
  network = {
    "pg-01" = ["", ""]  # using dhcp
  }
  vmgateway         = "10.13.113.1"
  dc        = "Datacenter"
  datastore = "Data Store name(use ds_cluster for datastore cluster)"
}
data "local_file" "pk" {
    filename = "./id.rsa"
}

module "nginx" {
   source = "./modules/app-nginx"
   server_ips = module.server-nginx.Linux-ip
   ssh_private_key = pk.content 
}

module "f5" {
  source = "./modules/infra-f5" 
  server_ips = module.server-nginx.Linux-ip
  policy_name = "nginx-demo"
  vip_ip = "10.0.0.5"
}