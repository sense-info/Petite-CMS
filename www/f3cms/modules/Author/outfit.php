<?php

namespace F3CMS;

/**
 * for render page
 */
class oAuthor extends Outfit
{
    function list($args)
    {
        $author = fAuthor::one(parent::_slugify($args['slug']), 'slug', ['status' => fAuthor::ST_ON], false);

        if (empty($author)) {
            f3()->error(404);
        }

        $subset = fPress::lotsByAuthor($author['id']);

        $subset['subset'] = \__::map($subset['subset'], function ($cu) {
            $cu['tags']    = fPress::lotsTag($cu['id'], true);
            $cu['authors'] = fPress::lotsAuthor($cu['id']);
            $cu['metas']   = fPress::lotsMeta($cu['id']);

            return $cu;
        });

        $seo = [
            'desc' => $author['title'] . ':' . $author['info'],
            'img'  => $author['pic'],
        ];

        f3()->set('page', $seo);

        f3()->set('rows', $subset);
        f3()->set('cate', $author);

        parent::wrapper('/press/list.html', $author['title'] . '的所有文章', '/author/' . $author['slug']);
    }
}
