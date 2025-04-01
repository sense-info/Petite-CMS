<?php

namespace F3CMS;

/**
 * for render page
 */
class oPost extends Outfit
{
    /**
     * @param $args
     */
    public static function home($args)
    {
        kPost::checkHomepageLang($args);

        $adv = kAdv::loadAry('board_home', [
            'top' => [
                'pid' => '6',
                'limit' => 3
            ],
            'bottom' => [
                'pid' => '7',
                'limit' => 6
            ],
        ], 0);

        _dzv('recommendation', []);
        _dzv('featured', []);

        if (!empty($adv['top']['data'])) {
            _dzv('recommendation', $adv['top']['data']);
            fAdv::addExposure(\__::pluck($adv['top']['data'], 'id'));
        }
        if (!empty($adv['bottom']['data'])) {
            _dzv('featured', $adv['bottom']['data']);
            fAdv::addExposure(\__::pluck($adv['bottom']['data'], 'id'));
        }

        parent::render('index.twig', '首頁', '/home');
    }
}
