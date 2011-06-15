server
{
    server_name  phpmyadmin.${domain};
    root /www/phpMyAdmin-3.3.9-all-languages;
    access_log off;
    include /webserver/etc/nginx/includes/serve_static;
    include /webserver/etc/nginx/includes/serve_php;
}

server {
  server_name  ${domain};
  rewrite ^ http://www.${domain}$request_uri permanent;
  access_log off;
}

server {
    server_name  *.${domain};
    access_log /webserver/log/nginx/${domain}.access.log;

    if ( $host ~* (.*)\.(.*)\.(.*) )
    {
        set $SLD $1;
    }
    if ( $SLD ~* ^(www|t)$ )
    {
        set $SLD '';
    }
    root /www/${domain}/public_html/$SLD;    

    # Give users their static files... FAST
    include /webserver/etc/nginx/includes/serve_static;
    # Let's give it PHP powers!
    include /webserver/etc/nginx/includes/serve_php;
}
