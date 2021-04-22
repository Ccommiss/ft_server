if [ $autoindex != "off" ]
then
	export autoindex=on
	sed -i '14d' /etc/nginx/sites-available/default
fi
if [ $autoindex = "off" ]
then
	sed -i '13d' /etc/nginx/sites-available/default
fi
service php7.3-fpm start
service nginx start
service mysql start
cd /var/www/html/wordpress/ && mariadb -e "source wp-launch.sql"
cd /var/www/html/wordpress/ && mariadb -e "source wp_paris.sql"
echo "Autoindex is set to $autoindex"
tail -f /dev/null
