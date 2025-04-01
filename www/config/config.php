<?php

$f3->set('AUTOLOAD', $webRootDir . 'modules/;' . $rootDir . 'f3cms/modules/;' . $rootDir . 'f3cms/libs/;/var/vendor/;');

$f3->set('vendors', '/var/vendor8/');

$f3->set('PACKAGE', 'F3CMS');

$f3->set('TEMP', $rootDir .'tmp/');

$f3->set('LOGS', $f3->get('TEMP') . 'logs/');

$f3->set('UI', $rootDir. 'theme/');

$f3->set('TZ', 'Asia/Taipei');

$f3->set('chkLogin', 0);

$f3->set('DEBUG', 2);

$f3->set('forceHTTPS', 0);

$f3->set('token_expired', 30);

$f3->set('passwd_expired', 90);

$f3->set('APP_ENV', getenv('APP_ENV'));

$f3->set('siteBeginDate', 'Dec 21 2021 12:00:00'); // remove this after online

$f3->set('abspath', $rootDir);

$f3->set('fe_version', '180807001');

$f3->set('rows_limit', 12);

$f3->set('cache.post', 5);
$f3->set('cache.press', 5);
$f3->set('cache.adv', 1); // 0 : only use published static file

// db setting
$f3->set('db_host', 'mariadb');
$f3->set('db_name', 'target_db');
$f3->set('db', 'mysql:host=' . $f3->get('db_host') . ';port=3306;dbname=' . $f3->get('db_name'));
$f3->set('db_account', 'root');
$f3->set('db_password', 'sPes4uBrEcHUq5qE');
$f3->set('tpf', 'tbl_');

$f3->set('uri', 'https://loc.f3cms.com:4433' . $f3->get('BASE'));

$f3->set('picUri', 'https://loc.f3cms.com:4433' . $f3->get('BASE'));

$f3->set('site_title', 'Demo');

$f3->set('theme', 'default');

$f3->set('defaultLang', 'tw');

$f3->set('acceptLang', ['tw', 'en']);

$f3->set('readyLang', [
    ['idx' => 'tw'],
    ['idx' => 'en']
]);

$f3->set('connectLineXml', 0);

// for Class:Upload
//thumbnail
$f3->set('post_thn', [300, 300]);
$f3->set('media_thn', [600, 600]);
$f3->set('author_thn', [400, 300]);
$f3->set('press_thn', [128, 128]);
$f3->set('adv_thn', [293, 293]);
$f3->set('default_thn', [600, 600]);
$f3->set('all_thn', [128, 128]);
// acceptable file type
$f3->set('photo_acceptable', [
    'image/pjpeg',
    'image/jpeg',
    'image/jpg',
    'image/gif',
    'image/png',
    'image/x-png',
    'application/octet-stream'
]);
//file upload max size
$f3->set('maxsize', 20971520);

//EMAIL
$f3->set('smtp_host', 'smtp.gmail.com');
$f3->set('smtp_port', 465);
$f3->set('smtp_account', 'sense.info.co@gmail.com');
$f3->set('smtp_password', ''); //
$f3->set('smtp_name', 'Trevor Pao');
$f3->set('smtp_from', 'sense.info.co@gmail.com');

$f3->set('webmaster', 'shuaib25@gmail.com');
