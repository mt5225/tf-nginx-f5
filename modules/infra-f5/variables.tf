variable "pool_name" {
  type        = string
  description = "pool name"
}

variable "monitors" {
  type    = list(any)
  default = ["/Common/http"]
}

variable "policy_name" {
  type = string
  description = "policy name"
}

variable "vip_id" {
  type = string
  description = "vip" 
}

variable "server_ips" {
  type = list 
  description = "number server ip array"
}