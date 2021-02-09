# ref: https://registry.terraform.io/modules/Terraform-VMWare-Modules/vm/vsphere/latest
# Deploy 2 linux VMs
module "server-nginx" {
  source        = "Terraform-VMWare-Modules/vm/vsphere"
  vmtemp        = "VM Template Name (Should Alrerady exist)"
  instances     = 2
  vmname        = "example-server-linux"
  vmrp          = "esxi/Resources - or name of a resource pool"
  network = {
    "Name of the Port Group in vSphere" = ["10.13.113.2", "10.13.113.3"] # To use DHCP create Empty list ["",""]
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
