<?php

$siteDir = 'loc.f3cms.com/';
$rootDir = __DIR__ . '/../';
$webRootDir = __DIR__ . '/';

require_once $rootDir .'f3cms/vendor/autoload.php';

require_once $rootDir .'f3cms/libs/Autoload.php';
require_once $rootDir .'f3cms/libs/Utils.php';

$f3 = \Base::instance();

// config
require $rootDir .'config/config.php';
require_once $rootDir . 'config/' . $siteDir . 'config.php';
require_once $rootDir . 'config/' . $siteDir . 'config.' . ($f3->get('APP_ENV')) . '.php';

setCORS(['https://loc.f3cms.com:4433', 'https://localhost:8080']); // local FE, FE demo site
if (isset($_SERVER['HTTP_ORIGIN'])) {
    $f3->set('isCORS', 1);
}

if (!is_https() && $f3->get('forceHTTPS') === 1) {
    $redirect = 'https://' . $_SERVER['HTTP_HOST'] . $_SERVER['REQUEST_URI'];
    header('HTTP/1.1 301 Moved Permanently');
    header('Location: ' . $redirect);
    exit();
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

    // safeCookie('PHPSESSID', $sess->sid());
} else {
    $f3->set('CACHE', true);
    new Session(function ($session) {
        $logger = new \Log('session.log');
        if (($ip = $session->ip()) != f3()->get('IP')) {
            $logger->write('user changed IP:' . $ip);
        } else {
            $logger->write('user changed browser/device:' . f3()->get('AGENT'));
        }
    }, 'CSRF');

    // safeCookie('PHPSESSID', session_id());
}

// Define routes
$f3->config($rootDir .'config/routes.ini');
$f3->config($rootDir . 'config/' . $siteDir . 'routes.ini');

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

// if ($_SERVER['SERVER_NAME'] !== 'loc.f3cms.com') {
if ($f3->get('APP_ENV') == 'qa' && $_SERVER['SERVER_NAME'] !== 'loc.f3cms.com') {
    $testing = $f3->get('SESSION.qa');
    if (!$testing || !$f3->exists('GET.qa')) {
        $isLegalQA = $f3->get('feVersion') == $f3->get('SESSION.qa') 
            || $f3->get('feVersion') == $f3->get('GET.qa') 
            || strpos($_SERVER['REQUEST_URI'], '/slack/action') === 0; // for 3th party api

        if ($isLegalQA) {
            $f3->set('SESSION.qa', $f3->get('feVersion'));
        } else {
            $f3->set('SESSION.qa', 0);
            $f3->reroute('https://sense-info.co'); // . $_SERVER['REQUEST_URI']
            exit();
        }
    }
    $f3->set('feVersion', date('YmdHis'));
}

$f3->run();
