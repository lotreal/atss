# server {
#   server_name www.domain.com domain.com;
#   root   /var/www/domain.com/htdocs;
#   access_log  /var/log/nginx/domain.access.log;
#
#   # Set of instructions to serve static files directly, without processing them: SPEED++++
#   include /etc/nginx/serve_static;
# }
