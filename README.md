# Petite CMS

Petite CMS 是一個效能卓越且安全可靠的內容管理系統 (CMS)，是適合用於建立和管理多語系、多站台式系統的架構


## 版本資訊

### LNMP
+ nginx alpine
+ php 8.1
+ maria 10


## 資料夾結構

```ini
conf           設定檔  
   apache      apache 設定檔  
   mysql       mysql 設定檔  
   nginx       nginx 設定檔
   php         php 設定檔  

database       資料庫檔案  

log            log  
   nginx       nginx log  
   mysql       mysql log  
   php         php log  

www            website 網站位置  
   cache       cache file
   config      config file
   f3cms       f3cms core
   pma         phpmyadmin 
   tmp         tmp file  
   vendor      php composer dir
```


## Set .env (local folder)

```ini
COMPOSE_PROJECT_NAME=pcms
APP_NAME=pcms

CONF_PATH=./../../conf
LOG_PATH=./../../log

### docker ######
DOCKER_CONF_PATH=./conf/docker


### apache/nginx ######

HOST_HTTP_PORT=8080
HOST_HTTPS_PORT=4433
WWW_PATH=./../../www
VND_PATH=PATH_TO_YOUR_VENDOR/www/f3cms/vendor


### php ######


### mysql ######

MYSQL_PORT=3366
MYSQL_ROOT_PASSWORD=sPes4uBrEcHUq5qE
MYSQL_DATABASE=target_db
MYSQL_USER=root
MYSQL_PASSWORD=sPes4uBrEcHUq5qE
MYSQL_DATA_PATH=./../../database

```


## Preparation

### host f3cms.lo
> 
> "0.0.0.0  loc.f3cms.com" >> /etc/hosts
> "0.0.0.0  my.f3cms.lo" >> /etc/hosts
> 

### Install Phpmyadmin
```sh
wget https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.zip
unzip phpMyAdmin-latest-all-languages.zip
mv phpMyAdmin-*/* ./www/pma
rm -rf phpMyAdmin-*

# composer update
```

## First build
```sh
./bin/build
```

## Start the Container
```sh
./bin/up
```

## Close the Container
```sh
./bin/down
```

## Clear images of Docker
```sh
./bin/clear
```

## Docker
```sh
docker exec -it nginx_pcms /bin/sh

docker exec nginx_pcms tail -f /var/log/nginx/error.log

docker logs nginx_pcms

docker restart nginx_pcms


docker exec -it php-fpm_pcms bash

cd f3cms
composer install

# Start the WebSocket server
export APP_ENV=qa && php /var/www/ws/index.php ssl://0.0.0.0:9527

export APP_ENV=develop && php /var/www/ws/index.php tcp://0.0.0.0:9527
```


## DB Init
open [my.f3cms.lo:4433/index.php](https://my.f3cms.lo:4433/index.php)  
and import conf/mysql/init.sql  
Or
```sh
mysql -uroot -p --port=3366 -h loc.f3cms.com target_db < ./conf/mysql/init.sql


mysql -uroot -p --port=3366 -h loc.f3cms.com stage_db < ./conf/mysql/stage-schema.sql
mysql -uroot -p --port=3366 -h loc.f3cms.com stage_db < ./conf/mysql/stage-onlydata.sql


```


## Loc SSL
```sh
cd ./conf/nginx/letsencrypt

mkcert loc.f3cms.com my.f3cms.lo
```


## Server Test
[loc.f3cms.com:4433](https://loc.f3cms.com:4433/)

## Crontab

設定排程後要檢查 logs 資料夾的權限
```sh
sudo chown trevor:www-data /www/Petite-CMS/www/tmp/logs
sudo chmod 775 /www/Petite-CMS/www/tmp/logs

sudo chown trevor:www-data /www/Petite-CMS/www/tmp/logs/*
sudo chmod 664 /www/Petite-CMS/www/tmp/logs/*
```

### crontab -e
```ini

*/5 * * * * export APP_ENV=stage && php8.1 /www/stage/www/cli/index.php /Minutely/5
1 * * * * export APP_ENV=stage && php8.1 /www/stage/www/cli/index.php /Hourly/1
1 0 * * * export APP_ENV=stage && php8.1 /www/stage/www/cli/index.php /Daily/1
1 0 1 * * export APP_ENV=stage && php8.1 /www/stage/www/cli/index.php /Monthly/1

```

### Test
```sh
export APP_ENV=stage && php8.1 /www/stage/www/cli/index.php /Hourly/1

export APP_ENV=stage && php8.1 /www/stage/www/cli/index.php /Daily/1

```

### Log
```sh
tail -f www/tmp/logs/_F3CMS_fPress_cronjob.log

```


## Coding Style
```sh
php-cs-fixer fix -v --using-cache=no
```

