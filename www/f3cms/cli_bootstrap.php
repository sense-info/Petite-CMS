<?php

if (!file_exists($rootDir .'f3cms/vendor/autoload.php')) {
    die('Please Install Vendor!');
}
require_once $rootDir .'f3cms/vendor/autoload.php';

require_once $rootDir .'f3cms/libs/Autoload.php';
require_once $rootDir .'f3cms/libs/Utils.php';

$f3 = \Base::instance();

// config
require $rootDir .'config/config.php';
require_once $rootDir . 'config/' . $siteDir . 'config.php';
require_once $rootDir . 'config/' . $siteDir . 'config.' . ($f3->get('APP_ENV')) . '.php';

$f3->set('TEMP', __DIR__ . '/../tmp/');
$f3->set('LOGS', $f3->get('TEMP').'logs/');
$f3->set('UI', __DIR__ . '/../f3cms/theme/');

$logger = new \Log('crontab.log');
$f3->set('cliLogger', $logger);

$logger->write('Info - 新排程');

if ($f3->get('crontabhost') != gethostname()) {
    $logger->write('Error - 本機不能執行排程');
    exit();
}

$f3->set('opts', \F3CMS\fOption::load('', 'Preload'));

// Define routes
$f3->route('GET /', function ($f3, $args) {
    echo PHP_EOL.'**'. $f3->get('site_title') .' CLI**'.PHP_EOL.PHP_EOL;
});

$f3->route('GET /@freq/@tally', '\F3CMS\rCrontab->do_job');
