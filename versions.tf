terraform {
  required_version = ">= 0.14"
  required_providers {
    bigip = {
      source = "F5Networks/bigip"
      version = "1.6.0"
    }
    vsphere = {
      source = "hashicorp/vsphere"
      version = "1.24.3"
    }
  }
}