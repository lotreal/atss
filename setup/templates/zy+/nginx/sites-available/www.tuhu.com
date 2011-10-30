server
{
    server_name  phpmyadmin.${_DOMAIN};
    root ${_WWW}/phpMyAdmin-3.3.9-all-languages;
    access_log ${_NGINX_LOG}/${_DOMAIN}-phpmyadmin.access.log;
    include ${_NGINX_ETC}/includes/serve_static;
    include ${_NGINX_ETC}/includes/serve_php;
}


server {
    server_name  ${_DOMAIN};
    # access_log ${_NGINX_LOG}/${_DOMAIN}.access.log;
    access_log off;
    root ${_WWW}/${_DOMAIN};
    error_page 404 = /404.html;
    include ${_NGINX_ETC}/includes/serve_static;
    include ${_NGINX_ETC}/includes/serve_php;
}
