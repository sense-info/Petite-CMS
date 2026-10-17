<?php

if (!defined('CORE_DIR') || !defined('SITE_DIR')) {
    throw new RuntimeException('CORE_DIR and SITE_DIR must be defined before loading bootstrap.');
}

$coreDir = rtrim(CORE_DIR, '/') . '/';
$siteRootDir = rtrim(SITE_DIR, '/') . '/';
$sitePublicDir = is_dir($siteRootDir . 'public/') ? $siteRootDir . 'public/' : $siteRootDir;
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
$webRootDir = $sitePublicDir;
$siteDir = $siteConfigDir . '/';

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
$f3->set('abspath', $projectRootDir);
$f3->set('webpath', $sitePublicDir);
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

if (isset($_SERVER['HTTP_ORIGIN'])) {
    $f3->set('isCORS', 1);
}

if (f3()->get('sessionBase') == 'database') {
    $sess = new \F3CMS\Mession(true, function ($session) {
        $logger = new \Log('session.log');
        if (($ip = $session->ip()) != f3()->get('IP')) {
            $logger->write('user changed IP:' . $ip);
        } else {
            $logger->write('user changed browser/device:' . f3()->get('AGENT'));
        }
    });

    $f3->set('sess', $sess);
} else {
    $f3->set('CACHE', 'folder=' . rtrim($f3->get('TEMP'), '/') . '/cache/');
    new Session(function ($session) {
        $logger = new \Log('session.log');
        if (($ip = $session->ip()) != f3()->get('IP')) {
            $logger->write('user changed IP:' . $ip);
        } else {
            $logger->write('user changed browser/device:' . f3()->get('AGENT'));
        }
    }, 'CSRF');
}

$routesFile = $activeCoreDir . 'config/routes.ini';
if (!file_exists($routesFile)) {
    $routesFile = $siteRootDir . 'config/routes.ini';
}
if (!file_exists($routesFile)) {
    $routesFile = $fallbackConfigRoot . 'routes.ini';
}
$f3->config($routesFile);

$siteRoutesFile = $siteRootDir . 'config/routes.site.ini';
if (!file_exists($siteRoutesFile)) {
    $siteRoutesFile = $fallbackConfigRoot . $siteConfigDir . '/routes.ini';
}
if (file_exists($siteRoutesFile)) {
    $f3->config($siteRoutesFile);
}

if ($f3->get('DEBUG') == 0) {
    $f3->set('ONERROR', function ($f3) {
        $isAjax = !empty($_SERVER['HTTP_X_REQUESTED_WITH']) && strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest';
        if ($isAjax) {
            \F3CMS\Reaction::_return(404);
        } else {
            $error = $f3->get('ERROR');
            _dzv('ERROR', [
                'code' => $error['code'],
                'text' => $error['text'],
            ]);
            \F3CMS\Outfit::render('error.twig', 'Not Found', '/404');
        }
    });
}

$_SERVER['HTTP_ORIGIN'] = (empty($_SERVER['HTTP_ORIGIN'])) ? null : $_SERVER['HTTP_ORIGIN'];
$_SERVER['HTTP_USER_AGENT'] = (empty($_SERVER['HTTP_USER_AGENT'])) ? '' : $_SERVER['HTTP_USER_AGENT'];

if ($f3->get('APP_ENV') == 'qa' && $_SERVER['SERVER_NAME'] !== 'loc.f3cms.com') {
    $testing = $f3->get('SESSION.qa');
    if (!$testing || !$f3->exists('GET.qa')) {
        $isLegalQA = $f3->get('feVersion') == $f3->get('SESSION.qa')
            || $f3->get('feVersion') == $f3->get('GET.qa')
            || strpos($_SERVER['REQUEST_URI'], '/slack/action') === 0;

        if ($isLegalQA) {
            $f3->set('SESSION.qa', $f3->get('feVersion'));
        } else {
            $f3->set('SESSION.qa', 0);
            $f3->reroute('https://sense-info.co');
            exit();
        }
    }
}
