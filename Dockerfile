FROM debian:buster

RUN apt-get update -y
RUN apt-get install -y vim

#pour nginx
RUN apt-get install -y nginx
RUN apt-get install -y mariadb-server mariadb-client
# ???

# RUN mysql_install_db
RUN apt-get install -y php php7.3 php7.3-fpm php7.3-mysql php-common php7.3-cli php7.3-common php7.3-json php7.3-opcache php7.3-readline php-curl php-gd php-intl php-mbstring php-soap php-xml php-xmlrpc php-zip



#Add PHP processor
COPY default /etc/nginx/sites-available/default

## dedans : faire service php7.3-fpm start
## + service nginx start
## + service mysql start


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

RUN cd /var/www/html/wordpress/ && mariadb -e "source wp-launch.sql"
RUN cd /var/www/html/wordpress/ && mariadb -e "source wp_paris.sql"




# RUN chown -R www-data:www-data /var/www/html/wordpress

#POUR PHP
# RUN mkdir /var/www/your_domain/
## RUN touch /var/www/your_domain/html/index.html
# RUN chown -R $USER:$USER /var/www/your_domain
# COPY your_domain /etc/nginx/sites-available/your_domain
# RUN ln -s /etc/nginx/sites-available/your_domain /etc/nginx/sites-enabled/
RUN nginx -t
# RUN service nginx reload

COPY test.php /var/www/html/test.php


## pour le pare feu amis askip pas besoin
## RUN apt-get install -y ufw






##pour avoir un bo shell
#RUN apt-get install -y wget
#RUN apt-get install -y git
#RUN apt-get install -y zsh
#RUN sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

RUN service nginx start
