<?php

namespace F3CMS;

/**
 * for render page
 */
class oTag extends Outfit
{
    /**
     * @param $args
     *
     * @return mixed
     */
    public static function show($args)
    {
        if (is_numeric($args['slug'])) {
            $tag = fTag::one($args['slug'], 'id', ['status' => fTag::ST_ON], false);
        } else {
            $tag = fTag::one(parent::_slugify($args['slug']), 'slug', ['status' => fTag::ST_ON], false);
        }

        if (empty($tag)) {
            f3()->error(404);
        }

        // $subset = fPress::lotsByTag($tag['id']);

        // $subset['subset'] = \__::map($subset['subset'], function ($cu) {
        //     $cu['tags'] = fPress::lotsTag($cu['id']);
        //     $cu['authors'] = fPress::lotsAuthor($cu['id']);
        //     $cu['metas'] = fPress::lotsMeta($cu['id']);

        //     return $cu;
        // });

        // _dzv('rows', $subset);
        _dzv('cu', $tag);
        _dzv('srcType', 'tag');

        self::render('press/list.twig', $tag['title'], '/tag/' . $tag['slug']);
    }
}
