<?php

$siteRoot = dirname(__DIR__);

define('SITE_DIR', $siteRoot);

$coreDir = getenv('CORE_DIR');
if (!$coreDir) {
    $coreDir = dirname(dirname($siteRoot)) . '/core';
}
if (!is_dir($coreDir)) {
    $coreDir = dirname($siteRoot) . '/f3cms';
}

define('CORE_DIR', $coreDir);
define('SITE_CONFIG_DIR', 'demo');

require_once CORE_DIR . '/bootstrap.php';

$f3->run();
