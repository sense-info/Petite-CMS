<?php

$config = require '.php-cs-fixer.dist.php';

$config->setRules(array_merge($config->getRules(), [
    'visibility_required' => false,
    'no_superfluous_phpdoc_tags' => false
]));

return $config;
