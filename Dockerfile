FROM debian:buster

RUN apt-get update -y
RUN apt-get install -y nginx
RUN apt-get install -y mariadb-server mariadb-client
RUN apt-get install -y php php7.3 php7.3-fpm php7.3-mysql php-common php7.3-cli php7.3-common php7.3-json php7.3-opcache php7.3-readline php-curl php-gd php-intl php-mbstring php-soap php-xml php-xmlrpc php-zip
#Add PHP processor
COPY srcs/default /etc/nginx/sites-available/default
#Add SSL configuration
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -subj "/C=FR/ST= /L= /O= /CN=localhost" -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt
RUN openssl dhparam -out /etc/nginx/dhparam.pem 1024
COPY srcs/self-signed.conf /etc/nginx/snippets/self-signed.conf
COPY srcs/ssl-params.conf /etc/nginx/snippets/ssl-params.conf
#PHPMY ADMIN
COPY srcs/phpmyadmin /var/www/html/phpmyadmin
RUN chown www-data.www-data /var/www/html/phpmyadmin -R
COPY srcs/config.inc.php /var/www/html/phpmyadmin/config.inc.php
#WORDPRESS
COPY srcs/wordpress /var/www/html/wordpress
COPY srcs/wp-config.php /var/www/html/wordpress/
COPY srcs/wp-launch.sql /var/www/html/wordpress/
COPY srcs/wp_paris.sql /var/www/html/wordpress/
#Launch script to start services (php, wp, mariadb)
COPY srcs/launch.sh /var/
ENV autoindex=on
CMD bash /var/launch.sh