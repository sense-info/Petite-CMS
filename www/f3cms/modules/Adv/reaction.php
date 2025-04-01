<?php

namespace F3CMS;

/**
 * React any request
 */
class rAdv extends Reaction
{
    /**
     * @return mixed
     */
    public function do_load()
    {
        $req = parent::_getReq();

        $req['meta'] = (!empty($req['meta'])) ? 1 : 0;

        $limit = max(min($req['limit'] * 1, 12), 3);

        $rtn = [];

        if (0 != f3()->get('cache.adv')) {
            $fc  = new FCHelper('board');
            $rtn = $fc->get('board_' . $req['pid'] . 'x' . $limit, f3()->get('cache.adv')); // 1 mins

            if (empty($rtn)) {
                $rtn = self::_render($req['pid'], $limit, $req['meta']);
            } else {
                $rtn = json_decode(preg_replace('/<!--(?!\s*(?:\[if [^\]]+]|<!|>))(?:(?!-->).)*-->/s', '', $rtn), true);
            }
        } else {
            $rtn = self::_render($req['pid'], $limit, $req['meta']);
        }

        fAdv::addExposure(\__::pluck($rtn, 'id'));

        return self::_return(1, $rtn);
    }

    /**
     * @param $f3
     * @param $args
     */
    public function do_pass($f3, $args)
    {
        $row = fAdv::one((int) f3()->get('GET.id'), 'id', ['status' => fAdv::ST_ON]);

        // when adv is expired, link still can be reroute!!

        if (null == $row) {
            f3()->error(404);
        }

        fAdv::addCounter($row['id']);

        f3()->reroute($row['uri']);
    }

    /**
     * @param array $row
     *
     * @return mixed
     */
    public static function handleRow($row = [])
    {
        // $row['positions'] = array_values(fAdv::getPositions());
        $row['meta'] = fAdv::lotsMeta($row['id']);

        return $row;
    }

    /**
     * @param $id
     * @param $limit
     *
     * @return mixed
     */
    private static function _render($id = 1, $limit = 4, $meta = 0)
    {
        $rtn = fAdv::getResources($id, $limit, ' m.`weight` DESC ');

        if (empty($rtn)) {
            return [];
        }

        $rtn = \__::map($rtn, function ($cu) use ($meta) {
            if (1 == $meta) {
                $cu['meta'] = fAdv::lotsMeta($cu['id']);
            }

            $cu['link'] = '/r/pass?id=' . $cu['id'];
            unset($cu['uri']);

            return $cu;
        });

        $fc = new FCHelper('board');
        $fc->save('board_' . $id . 'x' . $limit, json_encode($rtn));

        return $rtn;
    }
}
