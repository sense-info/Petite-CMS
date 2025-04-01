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
        if (is_numeric($args['slug']) && 'chunyichang' != f3()->get('theme')) {
            $tag = fTag::one($args['slug'], 'id', ['status' => fTag::ST_ON], false);
        } else {
            $tag = fTag::one(parent::_slugify($args['slug']), 'slug', ['status' => fTag::ST_ON], false);
        }

        if (empty($tag)) {
            f3()->error(404);
        }

        $tag['tags'] = [];

        $subset = fPress::lotsByTag($tag['id'], 0, f3()->get('rows_limit'));

        $subset['subset'] = \__::map($subset['subset'], function ($cu) {
            $cu['tags']    = fPress::lotsTag($cu['id'], true);
            $cu['authors'] = fPress::lotsAuthor($cu['id']);
            $cu['metas']   = fPress::lotsMeta($cu['id']);

            return $cu;
        });

        f3()->set('rows', $subset);
        f3()->set('cate', $tag);
        f3()->set('act_link', $args['slug']);

        $backList = '/' . Module::_lang() . '/tag/' . $args['slug'] . ((isset($args['whatever'])) ? '/' . $args['whatever'] : '');

        f3()->set('SESSION.back_list', $backList);

        parent::wrapper('/press/list.html', $tag['title'], '/tag/' . $tag['slug']);
    }
}
