<?php

namespace F3CMS;

/**
 * for render page
 */
class oAuthor extends Outfit
{
    public static function show($args)
    {
        $author = fAuthor::one(parent::_slugify($args['slug']), 'slug', ['status' => fAuthor::ST_ON], false);

        if (empty($author)) {
            f3()->error(404);
        }

        // $subset = fPress::lotsByAuthor($author['id']);

        // $subset['subset'] = \__::map($subset['subset'], function ($cu) {
        //     $cu['tags'] = fPress::lotsTag($cu['id']);
        //     // $cu['authors'] = fPress::lotsAuthor($cu['id']);
        //     // $cu['metas'] = fPress::lotsMeta($cu['id']);

        //     return $cu;
        // });
        //

        $author['title'] = $author['title'] . '的所有文章';

        $seo = [
            'desc' => $author['summary'],
            'img'  => $author['cover'],
        ];

        _dzv('page', $seo);

        // _dzv('rows', $subset);
        _dzv('cu', $author);
        _dzv('srcType', 'author');

        self::render('press/list.twig', $author['title'], '/author/' . $author['slug']);
    }
}
