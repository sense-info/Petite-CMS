<?php

if (PHP_SAPI != 'cli') {
    die('Only in cli mode');
}

$siteDir = 'loc.f3cms.com/';

$rootDir = __DIR__ . '/../';
$webRootDir = __DIR__ . '/';

require_once $rootDir .'f3cms/cli_bootstrap.php';

$f3->run();

