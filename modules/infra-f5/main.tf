# create ltm pool
resource "bigip_ltm_pool" "this" {
  name                = var.pool_name
  monitors            = var.monitors
  allow_nat           = "yes"
  allow_snat          = "yes"
  load_balancing_mode = "round-robin"
}

# add nodes to pool
resource "bigip_ltm_pool_attachment" "attach_node" {
  count = length(var.server_ips)
  pool  = bigip_ltm_pool.this.name
  node  = "${element(var.server_ips, count.index)}:80"
}

# apply policy
resource "bigip_ltm_policy" "this" {
  name           = var.policy_name
  strategy       = "first-match"
  requires       = ["http"]
  published_copy = "Drafts/my_policy"
  controls       = ["forwarding"]
  rule {
    name = "rule6"
    action = {
      tm_name = "20"
      forward = true
      pool    = "/Common/mypool"
    }
  }
  depends_on = [bigip_ltm_pool.this]
}

# create Virtual server with SSL enabled and assoiate with pool
resource "bigip_ltm_virtual_server" "https" {
  name                       = "/Common/terraform_vs_https"
  destination                = var.vip_ip
  description                = "VirtualServer-test"
  port                       = 443
  pool                       = bigip_ltm_pool.this.name
  profiles                   = ["/Common/tcp", "/Common/my-awesome-ssl-cert", "/Common/http"]
  source_address_translation = "automap"
  translate_address          = "enabled"
  translate_port             = "enabled"
}


