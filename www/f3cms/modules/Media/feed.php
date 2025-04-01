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

    const PV_SOP = 'see.other.press';

    const MULTILANG = 0;

    const BE_COLS = 'm.id,m.title,m.slug,m.status,m.pic,info,m.last_ts';

    /**
     * @param $req
     */
    public static function insert($req)
    {
        $now = date('Y-m-d H:i:s');

        $data = [
            'title'     => $req['title'],
            'slug'      => $req['slug'],
            'pic'       => $req['pic'],
            'status'    => self::ST_ON,
            'last_ts'   => $now,
            'insert_ts' => $now,
        ];

        mh()->insert(self::fmTbl(), $data);

        return self::chkErr(mh()->id());
    }

    /**
     * @param $query
     * @param $page
     * @param $limit
     * @param $cols
     *
     * @return mixed
     */
    public static function limitRows($query = '', $page = 0, $limit = 12, $cols = '')
    {
        $filter = self::genQuery($query);

        // if (!canDo(self::PV_SOP)) {
        // $filter['m.insert_user'] = fStaff::_current();
        // }

        if (!empty($filter['m.target'])) {
            $filter['m.status'] = self::ST_ON;
        }

        $filter['ORDER'] = ['m.insert_ts' => 'DESC'];

        $join = ['[>]' . fStaff::fmTbl() . '(s)' => ['m.insert_user' => 'id']];

        return self::paginate(self::fmTbl() . '(m)', $filter, $page, $limit, explode(',', self::BE_COLS), $join);
    }
}
