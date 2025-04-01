<?php

namespace F3CMS;

/**
 * for render page
 */
class oGenus extends Outfit
{
    /**
     * @param $args
     *
     * @return mixed
     */
    public static function show($args)
    {
        if (is_numeric($args['slug']) && 'chunyichang' != f3()->get('theme')) {
            $genus = fGenus::one($args['slug'], 'id', ['status' => fGenus::ST_ON], false);
        } else {
            $genus = fGenus::one(parent::_slugify($args['slug']), 'slug', ['status' => fGenus::ST_ON], false);
        }

        if (empty($genus)) {
            f3()->error(404);
        }

        $genus['tags'] = fGenus::lotsTag($genus['id'], true);

        $filter = [
            'm.category_id' => $genus['id'],
            'm.status'      => [fPress::ST_PUBLISHED, fPress::ST_CHANGED],
        ];
        if (!empty($args['tag']) && !empty($genus['tags'])) {
            $tag = fTag::one(parent::_slugify($args['tag']), 'slug', ['status' => fTag::ST_ON], false);
            if (empty($tag)) {
                f3()->error(404);
            }

            $ids = fPress::byTag($tag['id']);
            if (!empty($ids)) {
                $filter['m.id'] = $ids;
            } else {
                $filter['m.id'] = '0';
            }
            f3()->set('subtag', $tag['slug']);
        } else {
            f3()->set('subtag', '');
        }

        $subset = fPress::limitRows($filter, 0, f3()->get('rows_limit'));

        $subset['subset'] = \__::map($subset['subset'], function ($cu) {
            $cu['tags']    = fPress::lotsTag($cu['id'], true);
            $cu['authors'] = fPress::lotsAuthor($cu['id']);
            $cu['metas']   = fPress::lotsMeta($cu['id']);

            return $cu;
        });

        f3()->set('rows', $subset);
        f3()->set('cate', $genus);
        f3()->set('act_link', $args['slug']);

        $backList = '/' . Module::_lang() . '/category/' . $args['slug'] . ((isset($args['whatever'])) ? '/' . $args['whatever'] : '');

        f3()->set('SESSION.back_list', $backList);

        parent::wrapper('/press/list.html', $genus['title'], '/category/' . $genus['slug']);
    }
}
