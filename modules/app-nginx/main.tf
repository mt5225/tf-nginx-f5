data "template_file" "nginx_server_node_http" {
  template = "server $${node_ip}:80 max_fails=3 fail_timeout=5s;"
  count    = length(var.server_ips)

  vars {
    node_ip = element(var.server_ips, count.index)
  }
}

data "template_file" "nginx_server_node" {
  template = "server $${node_ip}:443 max_fails=3 fail_timeout=5s;"
  count    = length(var.server_ips)

  vars {
    node_ip = element(var.server_ips, count.index)
  }
}

data "template_file" "nginx_conf" {
  template = <<EOF
worker_processes 2;
worker_rlimit_nofile 20000;

events {
    worker_connections 4096;
}

stream {
    upstream rancher_servers {
        least_conn;
        $${servers}
    }
    server {
        listen     443;
        proxy_pass rancher_servers;
    }
    
    upstream rancher_servers_http {
        least_conn;
        $${servers_http}
    }
    server {
        listen     80;
        proxy_pass rancher_servers_http;
    }
    
}
EOF

vars {
    servers      = join("\n        ",  data.template_file.nginx_server_node.*.rendered)
    servers_http = join("\n        ", data.template_file.nginx_server_node_http.*.rendered)
  }
}

resource "null_resource" "configure_lb" {
  count = length(var.server_ips)

  triggers = {
    template = "${data.template_file.nginx_conf.rendered}"
  }

  # provide some connection info
  connection {
    type        = "ssh"
    user        = "root"
    private_key = "${file(var.ssh_private_key)}"
    host        = element(var.server_ips, count.index)
  }

  
  provisioner "remote-exec" {
    inline = <<EOF
    apt-get update -y
    apt-get upgrade -y
    apt-get install nginx -y
    wget https://raw.githubusercontent.com/nginxinc/NGINX-Demos/master/nginx-hello/index.html --output-document /usr/share/nginx/html/index.html
    wget https://raw.githubusercontent.com/nginxinc/NGINX-Demos/master/nginx-hello/hello.conf --output-document /etc/nginx/sites-enabled/default
    systemctl restart nginx
EOF 
  }

  provisioner "file" {
    content     = "${data.template_file.nginx_conf.rendered}"
    destination = "/etc/nginx/nginx.conf"
  }

  provisioner "remote-exec" {
    inline = "systemctl restart nginx"
  }
}