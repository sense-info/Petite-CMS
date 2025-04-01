f3CMS
======

Small CMS by F3.

## Documentation

### PHP 8.1

```bash
sudo apt install php8.1-fpm php8.1-common php8.1-mysql php8.1-gmp php8.1-curl php8.1-intl php8.1-mbstring php8.1-xmlrpc php8.1-gd php8.1-xml php8.1-cli php8.1-zip php8.1-imagick -y

sudo service php8.1-fpm status
sudo service php8.1-fpm restart 

sudo vim /etc/php/8.1/fpm/php.ini


rm composer.lock

composer install

composer require bcosca/fatfree-core ikkez/f3-opauth phpoffice/phpspreadsheet tecnickcom/tcpdf mailgun/mailgun-php symfony/http-client nyholm/psr7 \
    aws/aws-sdk-php intervention/image maciejczyzewski/bottomline catfan/medoo twig/twig rakit/validation


```

### Links

* Home page - [https://github.com/trevorpao/f3cms](https://github.com/trevorpao/f3cms)
* Demo page - [https://trevorpao.github.io/f3cms/](https://trevorpao.github.io/f3cms/)

### Dependencies
- [fatfreeframework](https://fatfreeframework.com/3.6/home)

### Installation

At frist, you need to install this [SQL file](https://github.com/trevorpao/f3cms/blob/master/libs/sql/init.sql). 

Then execute following command

    $ git clone https://github.com/trevorpao/f3cms.git ./ 
    $ composer install
    $ cp config.sample.php config.php
    $ vim config.php

Enjoy!

### If No Composer

    $ curl -sS https://getcomposer.org/installer | php
    $ mv composer.phar /usr/local/bin/composer

## Bug tracker

If you find a bug, please report it [here on Github](https://github.com/trevorpao/f3cms/issues)!
