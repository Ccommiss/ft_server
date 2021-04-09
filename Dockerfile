FROM debian:buster

RUN apt-get update

#pour nginx 
RUN apt-get install -y nginx
RUN service nginx start 
RUN mkdir -p /var/www/your_domain/html
RUN vim /var/www/your_domain/html/index.html

## pour le pare feu amis askip pas besoin 
RUN apt-get install -y ufw

RUN apt-get install -y vim





##pour avoir un bo shell 
RUN apt-get install -y wget
RUN apt-get install -y git
RUN apt-get install -y zsh
RUN sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"