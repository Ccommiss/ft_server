FROM debian:buster

RUN apt-get update -y
RUN apt-get install -y vim


RUN apt-get install -y nginx
RUN apt-get install -y mariadb-server mariadb-client
RUN apt-get install -y php php7.3 php7.3-fpm php7.3-mysql php-common php7.3-cli php7.3-common php7.3-json php7.3-opcache php7.3-readline php-curl php-gd php-intl php-mbstring php-soap php-xml php-xmlrpc php-zip

#Add PHP processor
COPY default /etc/nginx/sites-available/default
# pour ssl
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=www.example.com" -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt
RUN openssl dhparam -out /etc/nginx/dhparam.pem 1024
COPY self-signed.conf /etc/nginx/snippets/self-signed.conf
COPY ssl-params.conf /etc/nginx/snippets/ssl-params.conf

## WORDPRESS
RUN apt-get install -y curl
RUN apt-get install -y wget
RUN cd /var/www/html/ && curl -O https://wordpress.org/latest.tar.gz
RUN cd /var/www/html/ && tar -xvf latest.tar.gz

## PHPMY ADMIN
RUN apt-get install -y unzip
RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.1.0/phpMyAdmin-5.1.0-all-languages.zip
RUN unzip phpMyAdmin-5.1.0-all-languages.zip
RUN mv phpMyAdmin-5.1.0-all-languages phpmyadmin
RUN mv phpmyadmin /var/www/html/
RUN chown www-data.www-data /var/www/html/phpmyadmin -R

COPY config.inc.php /var/www/html/phpmyadmin/config.inc.php
COPY wp-config.php /var/www/html/wordpress/
COPY wp-launch.sql /var/www/html/wordpress/
COPY wp_paris.sql /var/www/html/wordpress/


#POUR PHP
COPY launch.sh /var/
ENV autoindex=on
RUN echo $autoindex
CMD bash /var/launch.sh && bash


## pour le pare feu amis askip pas besoin
## RUN apt-get install -y ufw






##pour avoir un bo shell
#RUN apt-get install -y wget
#RUN apt-get install -y git
#RUN apt-get install -y zsh
#RUN sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"


