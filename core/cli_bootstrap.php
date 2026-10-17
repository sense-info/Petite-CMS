<?php

if (!defined('CORE_DIR') || !defined('SITE_DIR')) {
    throw new RuntimeException('CORE_DIR and SITE_DIR must be defined before loading cli bootstrap.');
}

$coreDir = rtrim(CORE_DIR, '/') . '/';
$siteRootDir = rtrim(SITE_DIR, '/') . '/';
$projectRootDir = dirname($siteRootDir) . '/';
$fallbackCoreDir = $projectRootDir . 'f3cms/';
$activeCoreDir = is_dir($coreDir . 'libs') ? $coreDir : $fallbackCoreDir;

if (!file_exists($activeCoreDir . 'vendor/autoload.php')) {
    throw new RuntimeException('Please install vendor dependencies.');
}

require_once $activeCoreDir . 'vendor/autoload.php';
require_once $activeCoreDir . 'libs/Autoload.php';
require_once $activeCoreDir . 'libs/Utils.php';

$f3 = \Base::instance();

$siteConfigDir = defined('SITE_CONFIG_DIR') ? SITE_CONFIG_DIR : basename(rtrim($siteRootDir, '/'));
$fallbackConfigRoot = $projectRootDir . 'config/';
$sharedModulesDir = $projectRootDir . 'modules/';
$sharedThemeRootDir = $projectRootDir . 'theme/';

$rootDir = $projectRootDir;
$siteDir = $siteConfigDir . '/';
$webRootDir = $siteRootDir . '/';

$sharedConfigFile = $activeCoreDir . 'config/config.php';
if (!file_exists($sharedConfigFile)) {
    $sharedConfigFile = $siteRootDir . 'config/config.php';
}
if (!file_exists($sharedConfigFile)) {
    $sharedConfigFile = $fallbackConfigRoot . 'config.php';
}
require $sharedConfigFile;

$siteConfigFile = $siteRootDir . 'config/site.config.php';
if (!file_exists($siteConfigFile)) {
    $siteConfigFile = $fallbackConfigRoot . $siteConfigDir . '/config.php';
}
if (file_exists($siteConfigFile)) {
    require_once $siteConfigFile;
}

$env = (string) $f3->get('APP_ENV');
$envConfigFile = $siteRootDir . 'config/config.' . $env . '.php';
if (!file_exists($envConfigFile)) {
    $envConfigFile = $fallbackConfigRoot . $siteConfigDir . '/config.' . $env . '.php';
}
if ($env !== '' && file_exists($envConfigFile)) {
    require_once $envConfigFile;
}

$autoload = $siteRootDir . 'modules/;' . $sharedModulesDir . ';' . $activeCoreDir . 'modules/;' . $activeCoreDir . 'libs/;/var/vendor/;';
$f3->set('AUTOLOAD', $autoload);

$f3->set('TEMP', $siteRootDir . 'tmp/');
$f3->set('LOGS', $f3->get('TEMP') . 'logs/');
$f3->set('core_configpath', $activeCoreDir . 'config');
$themeName = (string) $f3->get('theme');
$siteThemeRootDir = $siteRootDir . 'theme/';
$themeRootDir = $activeCoreDir . 'theme/';
if ($themeName !== '' && is_dir($siteThemeRootDir . $themeName)) {
    $themeRootDir = $siteThemeRootDir;
} elseif ($themeName !== '' && is_dir($sharedThemeRootDir . $themeName)) {
    $themeRootDir = $sharedThemeRootDir;
}
$f3->set('UI', $themeRootDir);

$logger = new \Log('crontab.log');
$f3->set('cliLogger', $logger);

$logger->write('Info - 新排程');

if ($f3->get('crontabhost') != gethostname()) {
    $logger->write('Error - 本機不能執行排程');
    exit();
}

$f3->set('opts', \F3CMS\fOption::load('', 'Preload'));

$f3->route('GET /', function ($f3, $args) {
    echo PHP_EOL . '**' . $f3->get('site_title') . ' CLI**' . PHP_EOL . PHP_EOL;
});

$f3->route('GET /@freq/@tally', '\F3CMS\rCrontab->do_job');
