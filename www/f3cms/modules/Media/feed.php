<?php

namespace F3CMS;

/**
 * data feed
 */
class fMedia extends Feed
{
    const MTB = 'media';

    const ST_ON  = 'Enabled';
    const ST_OFF = 'Disabled';

    const PV_SOP = 'mgr.cms';

    const MULTILANG = 0;

    const BE_COLS = 'm.id,m.title,m.target,m.slug,m.status,m.pic,info,m.last_ts';

    /**
     * @param $req
     */
    public static function insert($req)
    {
        $now = date('Y-m-d H:i:s');

        $data = [
            'title'     => $req['title'],
            'slug'      => $req['slug'],
            'parent_id' => $req['parent_id'],
            'target'    => ucfirst($req['target']),
            'pic'       => $req['pic'],
            'status'    => self::ST_ON,
            'last_ts'   => $now,
            'insert_ts' => $now,
        ];

        mh()->insert(self::fmTbl(), $data);

        return self::chkErr(mh()->id());
    }

    public static function genOrder()
    {
        return ['m.sorter' => 'ASC', 'm.insert_ts' => 'DESC'];
    }

    public static function genJoin()
    {
        return ['[>]' . fStaff::fmTbl() . '(s)' => ['m.insert_user' => 'id']];
    }
}
