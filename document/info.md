# Petite CMS

Petite CMS 是一個效能卓越且安全可靠的內容管理系統 (CMS)，是適合用於建立和管理多語系、多站台式系統的架構

## 新進工程師必讀
1. [flow.llm.md](./flow.llm.md)：最精簡的 FDD 執行契約（先讀這份再開始改動）。
2. [flow.md](./flow.md)：完整 FDD 流程與 gate 說明。
3. [guides/new_engineer_30min.md](./guides/new_engineer_30min.md)：30 分鐘上手與常見工作入口。
4. [guides/sd_conventions.md](./guides/sd_conventions.md)：模組邊界與程式設計慣例。
5. [guides/llm_dba_guide.md](./guides/llm_dba_guide.md)：資料庫與 ownership-first 決策原則。
6. [spec/.current-spec.md](./spec/.current-spec.md)：目前進行中的 spec 與 stage（做事前先確認）。


## 版本資訊

### LNMP
+ nginx alpine
+ php 8.3
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

core           f3cms core（config/libs/modules/vendor/theme/tmpls）

www            website 網站位置
   demo        範例站（public/config(site-only)/modules/tmp/cache）
   _infra      nginx 站點設定（*.conf）
   _pma        phpmyadmin
   _upload     共用上傳資料（demo 透過 public/upload 連結）
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
VND_PATH=PATH_TO_YOUR_VENDOR/core/vendor


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
mv phpMyAdmin-*/* ./www/_pma
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

cd /var/core
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

## 新站複製 SOP（含 upload 調整）
```sh
# 1) 複製範例站
cp -a www/demo www/client-a

# 2) upload 連結改到 client-a 專屬目錄
rm -f www/client-a/public/upload
ln -s ../../_upload/client-a www/client-a/public/upload

# 3) 建立 upload 目錄錨點（只追蹤 .gitkeep）
mkdir -p www/_upload/client-a
touch www/_upload/client-a/.gitkeep
```

並調整 `www/client-a/config/site.config.php`：
- `upload_dir` 改為 `client-a/`

## Crontab

設定排程後要檢查 logs 資料夾的權限
```sh
sudo chown trevor:www-data /www/Petite-CMS/www/demo/tmp/logs
sudo chmod 775 /www/Petite-CMS/www/demo/tmp/logs

sudo chown trevor:www-data /www/Petite-CMS/www/demo/tmp/logs/*
sudo chmod 664 /www/Petite-CMS/www/demo/tmp/logs/*
```

### crontab -e
```ini

*/5 * * * * export APP_ENV=qa && php8.3 /www/Petite-CMS/www/demo/cli.php /Minutely/5
1 * * * * export APP_ENV=qa && php8.3 /www/Petite-CMS/www/demo/cli.php /Hourly/1
1 0 * * * export APP_ENV=qa && php8.3 /www/Petite-CMS/www/demo/cli.php /Daily/1
1 0 1 * * export APP_ENV=qa && php8.3 /www/Petite-CMS/www/demo/cli.php /Monthly/1

```

### Test
```sh
export APP_ENV=qa && php8.3 /www/Petite-CMS/www/demo/cli.php /Hourly/1

export APP_ENV=qa && php8.3 /www/Petite-CMS/www/demo/cli.php /Daily/1

```

### Log
```sh
tail -f www/demo/tmp/logs/_F3CMS_fPress_cronjob.log

```


## Coding Style
```sh
php-cs-fixer fix -v --using-cache=no
```
