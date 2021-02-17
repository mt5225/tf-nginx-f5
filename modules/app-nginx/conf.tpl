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