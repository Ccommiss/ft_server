FROM debian:buster

RUN apt-get update
EXPOSE 80

#pour nginx 
RUN apt-get install -y nginx
# RUN apt-get install -y mariadb-server
# ???

# RUN mysql_install_db 


##RUN /usr/bin/mysqld_safe &
##RUN mysql_secure_installation 

# WP
RUN apt-get install -y php php-mysql php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip
RUN apt-get install -y curl
RUN cd /var/www/html/ && curl -O https://wordpress.org/latest.tar.gz
RUN cd /var/www/html/ && tar -xvf latest.tar.gz

RUN chown -R www-data:www-data /var/www/html/wordpress

RUN service nginx start 
#POUR PHP 

RUN mkdir /var/www/your_domain/
## RUN touch /var/www/your_domain/html/index.html
RUN chown -R $USER:$USER /var/www/your_domain
COPY your_domain /etc/nginx/sites-available/your_domain
RUN ln -s /etc/nginx/sites-available/your_domain /etc/nginx/sites-enabled/
RUN nginx -t
RUN service nginx reload

COPY test.php /var/www/your_domain/test.php
 

## pour le pare feu amis askip pas besoin 
## RUN apt-get install -y ufw

#RUN apt-get install -y vim





##pour avoir un bo shell 
#RUN apt-get install -y wget
#RUN apt-get install -y git
#RUN apt-get install -y zsh
#RUN sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

RUN service nginx start