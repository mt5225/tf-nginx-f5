# ref: https://registry.terraform.io/modules/Terraform-VMWare-Modules/vm/vsphere/latest
# Deploy 2 linux VMs
module "server-nginx" {
  source        = "./modules/infra-vmware"
  vmtemp        = "VM Template Name (Should Alrerady exist)"
  instances     = var.num 
  vmname        = "example-server-linux"
  vmrp          = "demo"
  network = {
    "pg-01" = ["", ""]  # using dhcp
  }
  vmgateway         = "10.13.113.1"
  dc        = "Datacenter"
  datastore = "ds01"
}


data "local_file" "pk" {
    filename = "./assets/id.rsa"
}

# install nginx
module "nginx" {
   source = "./modules/app-nginx"
   server_ips = module.server-nginx.Linux-ip
   ssh_private_key = pk.content 
}

# config F5
module "f5-config" {
  source = "./modules/infra-f5" 
  server_ips = module.server-nginx.Linux-ip
  policy_name = "nginx-demo"
  vip_ip = "10.0.0.5"
}