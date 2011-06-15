server
{
    # listen 27654;
    server_name  phpmyadmin.hxlady.com;
    root ${www}/phpMyAdmin-3.3.9-all-languages;
    access_log ${nginx_log}/phpmyadmin.access.log;
    include ${nginx_conf}/include/serve_static;
    include ${nginx_conf}/include/serve_php;
}

server {
  server_name  hxlady.com;
  rewrite ^ http://www.hxlady.com$request_uri permanent;
  access_log off;
}

server {
    server_name  *.hxlady.com;
    access_log /webserver/log/nginx/hxlady.com.access.log;

    if ( $host ~* (.*)\.(.*)\.(.*) )
    {
        set $SLD $1;
    }
    if ( $SLD ~* ^(www|test)$ )
    {
        set $SLD '';
    }
    root /data/www/hxlady.com/public_html/$SLD;    

    # Give users their static files... FAST
    include /webserver/etc/nginx/includes/serve_static;
    # Let's give it PHP powers!
    include /webserver/etc/nginx/includes/serve_php;
    rewrite ^/ajax_crossdomain/(.*)$ /ajax_crossdomain.php?path=$1 last;
}
