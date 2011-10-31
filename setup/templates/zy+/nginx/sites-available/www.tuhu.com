server
{
    server_name  phpmyadmin.${_DOMAIN};
    root ${ATSS_WWW}/phpMyAdmin-3.3.9-all-languages;
    access_log ${ATSS_NGINX_LOG}/${_DOMAIN}-phpmyadmin.access.log;
    include ${ATSS_NGINX_CFG}/includes/serve_static;
    include ${ATSS_NGINX_CFG}/includes/serve_php;
}


server {
    server_name  ${_DOMAIN};
    # access_log ${ATSS_NGINX_LOG}/${_DOMAIN}.access.log;
    access_log off;
    root ${ATSS_WWW}/${_DOMAIN};
    error_page 404 = /404.html;
    include ${ATSS_NGINX_CFG}/includes/serve_static;
    include ${ATSS_NGINX_CFG}/includes/serve_php;
}
