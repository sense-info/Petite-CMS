<?php
/**
 * F3CMS
 */

declare(strict_types=1);

$finder = PhpCsFixer\Finder::create()
    // ->ignoreVCSIgnored(true)
    ->in([__DIR__ . '/www/f3cms/'])
    ->exclude([__DIR__ . '/www/f3cms/tmp/', __DIR__ . '/www/f3cms/cache/'])
    ->append([
        __FILE__,
    ])
;

$config = new PhpCsFixer\Config();
$config
    ->setRiskyAllowed(true)
    ->setRules([
        // base mode
        '@PSR2'           => true,
        '@PHP73Migration' => true,

        // adv mode
        '@Symfony'                      => true,
        // '@PhpCsFixer'                   => true,

        // overwrite
        'psr_autoloading'        => false,
        'heredoc_indentation'    => false,
        'strict_comparison'      => false,
        'concat_space'           => ['spacing' => 'one'],
        'binary_operator_spaces' => ['operators' => [
            '=>' => 'align',
            '='  => 'align',
        ]],
        'phpdoc_summary'                      => false,
        'general_phpdoc_annotation_remove'    => ['annotations' => ['expectedDeprecation']], // one should use PHPUnit built-in method instead
    ])
    ->setFinder($finder)
;

// special handling of fabbot.io service if it's using too old PHP CS Fixer version
if (false !== getenv('FABBOT_IO')) {
    try {
        PhpCsFixer\FixerFactory::create()
            ->registerBuiltInFixers()
            ->registerCustomFixers($config->getCustomFixers())
            ->useRuleSet(new PhpCsFixer\RuleSet($config->getRules()))
        ;
    } catch (PhpCsFixer\ConfigurationException\InvalidConfigurationException $e) {
        $config->setRules([]);
    } catch (UnexpectedValueException $e) {
        $config->setRules([]);
    } catch (InvalidArgumentException $e) {
        $config->setRules([]);
    }
}

return $config;
