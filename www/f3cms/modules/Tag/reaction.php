<?php

namespace F3CMS;

/**
 * Tag
 */
class rTag extends Reaction
{
    /**
     * @param $f3
     * @param $args
     */
    public function do_more($f3, $args)
    {
        // kMember::_chkLogin();

        $query = 'm.status:' . fPress::ST_PUBLISHED;

        $req = parent::_getReq();

        $req['page'] = intval($req['page']);
        $req['page'] = ($req['page']) ? ($req['page'] - 1) : 1;

        $req['limit'] = max(min($req['limit'] * 1, 24), 3);

        if (!empty($req['pid'])) {
            if (is_numeric($req['pid'])) {
                $tag = fTag::one($req['pid'], 'id', ['status' => fTag::ST_ON], false);
            } else {
                $tag = fTag::one(parent::_slugify($req['pid']), 'slug', ['status' => fTag::ST_ON], false);
            }
        } else {
            $tag = null;
        }

        if (!empty($tag)) {
            $rtn = fPress::lotsByTag($tag['id'], $req['page'], $req['limit']);
        } else {
            if (!empty($req['columnID'])) {
                if ('topic' == $req['columnType']) {
                    $query .= ',m.topic_id:' . intval($req['columnID']);
                } else {
                    $query .= ',m.column_id:' . intval($req['columnID']);
                }
            }

            $rtn = fPress::limitRows($query, $req['page'], $req['limit']);
        }

        foreach ($rtn['subset'] as $k => $row) {
            $rtn['subset'][$k]['tags']    = fPress::lotsTag($row['id']);
            $rtn['subset'][$k]['authors'] = fPress::lotsAuthor($row['id']);
        }

        return self::_return(1, $rtn);
    }

    /**
     * get one row
     *
     * @param object $f3   - $f3
     * @param array  $args - uri params
     */
    function do_getDetail($f3, $args)
    {
        kStaff::_chkLogin();

        $req = parent::_getReq();

        if (!isset($req['parent_id'])) {
            return self::_return(8004);
        }

        $cu = fTag::detail($req['parent_id']);

        if (empty($cu)) {
            $cu = ['id' => 0, 'parent_id' => $req['parent_id']];
        } else {
        }

        return self::_return(1, $cu);
    }

    /**
     * @param $f3
     * @param $args
     */
    public function do_list($f3, $args)
    {
        chkAuth(fTag::PV_R);
        $req = parent::_getReq();

        if (empty($req['query'])) {
            $req['query'] = [];
        }
        $req['page'] = (isset($req['page'])) ? ($req['page'] - 1) : 0;
        $rtn    = fTag::limitRows($req['query'], $req['page']);
        $groups = [];

        $origAry = fGenus::getOpts('tag', 'm.group');
        $origAry = array_merge([
            [
                'id'    => '0',
                'title' => '未選擇',
            ]
        ], $origAry);

        $idArray = array_column($origAry, 'id');
        $positions = array_combine($idArray, $origAry);

        foreach ($rtn['subset'] as $row) {
            $groups[$row['cate_id']]['title']  = $positions[$row['cate_id']]['title'];
            $groups[$row['cate_id']]['rows'][] = $row;
        }

        $rtn['subset'] = $groups;

        return parent::_return(1, $rtn);
    }

    /**
     * save whole form for backend
     *
     * @param object $f3   - $f3
     * @param array  $args - uri params
     */
    function do_saveDetail($f3, $args)
    {
        kStaff::_chkLogin();

        $req = parent::_getReq();

        if (!isset($req['id'])) {
            return self::_return(8004);
        }

        $id = fTag::save($req, 'detail');

        return self::_return(1, ['id' => $id]);
    }
}
