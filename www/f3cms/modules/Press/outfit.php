<?php

namespace F3CMS;

/**
 * for render page
 */
class oPress extends Outfit
{
    /**
     * @param $args
     *
     * @return mixed
     */
    public static function list($args)
    {
        // $req = parent::_getReq();

        // $req['page'] = ($req['page']) ? ($req['page'] - 1) : 0;

        // $subset = fPress::limitRows('status:' . fPress::ST_PUBLISHED, $req['page']);

        // $subset['subset'] = \__::map($subset['subset'], function ($cu) {
        //     $cu['tags'] = fPress::lotsTag($cu['id']);
        //     $cu['authors'] = fPress::lotsAuthor($cu['id']);
        //     $cu['metas'] = fPress::lotsMeta($cu['id']);

        //     return $cu;
        // });

        // _dzv('rows', $subset);
        //
        $langTxts = [
            'tw' => '文章清單',
            'en' => 'Articles',
            'jp' => '記事一覧',
            'ko' => '기사 목록',
        ];

        if (f3()->get('theme') == 'senseinfo') {
            $title = '專案實蹟';
        } else {
            $title = $langTxts[Module::_lang()]; // '文章清單';
        }

        _dzv('cu', ['title' => $title, 'id' => 0]);
        _dzv('srcType', 'tag');

        self::render('press/list.twig', $title, '/presses');
    }

    /**
     * @param $args
     */
    public static function show($args)
    {
        $fc = new FCHelper('press');

        if (0 === f3()->get('cache.press')) {
            $html = $fc->get('press_' . parent::_lang() . '_' . $args['slug']);

            if (empty($html)) {
                if (!kStaff::_isLogin()) {
                    f3()->error(404);
                } else {
                    $html = self::_render($args['slug']);
                }
            }
        } else {
            $html = $fc->get('press_' . parent::_lang() . '_' . $args['slug'], f3()->get('cache.press'));

            if (empty($html)) {
                $html = self::_render($args['slug']);
                $fc->save('press_' . parent::_lang() . '_' . $args['slug'], $html, f3()->get('cache.press'));
            }
        }

        echo $html;
        self::_showVariables();
    }

    /**
     * @param $args
     */
    public static function buildPage($args)
    {
        if (!kStaff::_isLogin()) {
            f3()->error(404);
        }

        $fc            = new FCHelper('press');
        $fc->ifHistory = 0;

        foreach (f3()->get('acceptLang') as $n) {
            parent::_lang(['lang' => $n]);

            $html = self::_render($args['slug'], false, true);
            $fc->save('press_' . $n . '_' . $args['slug'], $html); // renew cache
        }
    }

    /**
     * @param $args
     */
    public static function preview($args)
    {
        if (!kStaff::_isLogin()) {
            f3()->error(404);
        }

        echo self::_render($args['slug'], false);
    }

    /**
     * @param $id
     * @param $published
     *
     * @return mixed
     */
    private static function _render($id = 0, $published = true, $history = false)
    {
        $filter = [];
        if ($published) {
            $filter['status'] = [fPress::ST_PUBLISHED, fPress::ST_CHANGED];
        }

        if (is_numeric($id)) {
            $cu = fPress::one($id, 'id', $filter, 0);
        } else {
            $cu = fPress::one(parent::_slugify($id), 'slug', $filter, 0);
        }

        if (empty($cu)) {
            f3()->error(404);
        }

        $cate     = fCategory::one($cu['cate_id'], 'id', ['status' => fCategory::ST_ON], 0);
        $tags     = fPress::lotsTag($cu['id'], true);
        $authors  = fPress::lotsAuthor($cu['id']);
        $relateds = fPress::lotsRelated($cu['id']);
        // $books    = fPress::lotsBook($cu['id']);
        $terms    = fPress::lotsTerm($cu['id']);
        $metas    = fPress::lotsMeta($cu['id']);

        $seo = [
            'desc'    => $cu['info'],
            'img'     => f3()->get('uri') . ((empty($cu['banner'])) ? $cu['cover'] : $cu['banner']),
            'keyword' => '',
            'header'  => '文章',
        ];

        if (!empty($tags)) {
            $seo['keyword'] .= implode(',', \__::pluck($tags, 'title'));
        }

        if (safeCount($relateds) < 5 && safeCount($tags) > 0) {
            $limit    =  (5 - safeCount($relateds));
            $suffix   = fPress::relatedTag($cu['id'], \__::pluck($tags, 'id'), $limit);
            $relateds = (is_countable($relateds)) ? array_merge($relateds, $suffix) : $suffix;
        }

        if (safeCount($relateds) > 0) {
            foreach ($relateds as $k => $row) {
                $relateds[$k]['tags']    = fPress::lotsTag($row['id']);
                $relateds[$k]['authors'] = fPress::lotsAuthor($row['id']);
            }
        }

        $cu['content'] = parent::convertUrlsToLinks($cu['content']);

        $subset = fMedia::limitRows([
            'm.status' => fMedia::ST_ON,
            'm.target' => 'Press',
            'm.parent_id' => $cu['id'],
        ], 0, 30);

        _dzv('medias', $subset['subset']);

        _dzv('cu', $cu);
        _dzv('cate', $cate);
        _dzv('metas', $metas);
        _dzv('tags', $tags);
        _dzv('authors', $authors);
        _dzv('relateds', $relateds);
        // _dzv('books', $books);
        _dzv('terms', $terms);

        _dzv('next', fPress::neighbor($cu, 'next'));
        _dzv('prev', fPress::neighbor($cu, 'prev'));

        f3()->set('page', $seo);

        _dzv('ldjson', self::ldjson(
            $cu['title'],
            $seo['desc'],
            f3()->get('uri') . '/' . parent::_lang() . '/p/' . $cu['id'] . '/' . $cu['slug'],
            $seo['img'],
            $cu['last_ts'],
            $cu['online_date']
        ));

        kPress::fartherData($cu['id']);

        f3()->set('breadcrumb_sire', ['title' => '文章', 'slug' => '/presses', 'sire' => ['title' => '首頁', 'slug' => '/home']]);

        $html = self::render('press/show.twig', $cu['title'], '/p/' . $cu['id'] . '/' . $cu['slug'], true);

        if ($history) {
            kHistory::save('Press', $cu['id'], $cu['title'], $html);
        }

        return $html;
    }

    public static function ldjson($title, $desc, $link, $img, $last_ts, $online_date)
    {
        switch (parent::_lang()) {
            case 'en':
                $lang = 'en-US';
                break;
            case 'jp':
                $lang = 'ja-JP';
                break;
            case 'ko':
                $lang = 'ko-KR';
                break;
            default:
                $lang = 'zh-TW';
                break;
        }

        // TODO: use @graph, add ImageObject, BreadcrumbList, Person
        return '<script type="application/ld+json">' . jsonEncode([
          '@context'         => 'https://schema.org',
          '@type'            => 'NewsArticle',
          'headline'         => parent::safeRaw($title),
          'description'      => parent::safeRaw($desc),
          'contentUrl'       => $link,
          'image'            => [$img],
          'dateModified'     => date('c', strtotime($last_ts)),
          'datePublished'    => date('c', strtotime($online_date)),
          'inLanguage'       => $lang,
        ]) . '</script>';
    }
}
