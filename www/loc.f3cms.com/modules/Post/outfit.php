<?php
namespace PCMS;

require_once '../f3cms/modules/Press/feed.php';
require_once '../f3cms/modules/Adv/feed.php';
require_once '../f3cms/modules/Post/feed.php';
require_once '../f3cms/modules/Post/outfit.php';

use F3CMS\oPost as Elder;
use F3CMS\fPost as fPost;
use F3CMS\fAdv as fAdv;
use F3CMS\fPress as fPress;

/**
 * for render page
 */
class oPost extends Elder
{
    /**
     * @param $args
     */
    public static function home($args)
    {
        \F3CMS\kPost::checkHomepageLang($args);

        $adv = \F3CMS\kAdv::loadAry('board_home', [
            'top' => [
                'pid' => '6',
                'limit' => 3
            ],
            'middle' => [
                'pid' => '7',
                'limit' => 1
            ],
            'youtube' => [
                'pid' => '10',
                'limit' => 1
            ],
            'bottom' => [
                'pid' => '5',
                'limit' => 6
            ],
        ], 0);

        _dzv('hero', []);
        _dzv('recommendation', []);
        _dzv('intro', []);
        _dzv('links', []);

        if (!empty($adv['top']['data'])) {
            _dzv('hero', $adv['top']['data']);
            fAdv::addExposure(\__::pluck($adv['top']['data'], 'id'));
        }

        if (!empty($adv['middle']['data'])) {
            _dzv('recommendation', $adv['middle']['data']);
            fAdv::addExposure(\__::pluck($adv['middle']['data'], 'id'));
        }

        if (!empty($adv['youtube']['data'])) {
            _dzv('intro', $adv['youtube']['data']);
            fAdv::addExposure(\__::pluck($adv['youtube']['data'], 'id'));
        }

        if (!empty($adv['bottom']['data'])) {
            _dzv('links', $adv['bottom']['data']);
            fAdv::addExposure(\__::pluck($adv['bottom']['data'], 'id'));
        }

        $about = fPost::one('about-us-home', 'slug', ['status' => fPost::ST_ON], 0);
        _dzv('about', $about);

        $news = fPress::limitRows(['m.status' => [fPress::ST_PUBLISHED, fPress::ST_CHANGED]], 0, 3);
        foreach ($news['subset'] as $k => $row) {
            $news['subset'][$k]['authors'] = fPress::lotsAuthor($row['id']);
        }

        _dzv('news', $news['subset']);

        $partners = fPress::lotsByTag(10, 0, 3);
        _dzv('partners', $partners['subset']);

        parent::render('index.twig', '首頁', '/home');
    }
}
