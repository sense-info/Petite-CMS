<?php

namespace F3CMS;

/**
 * data feed
 */
class fAnnal extends Feed
{
    const MTB = 'annal';

    const ST_ON  = 'Enabled';
    const ST_OFF = 'Disabled';

    const MULTILANG = 0;

    const PV_R = 'mgr.site';
    const PV_U = 'mgr.site';
    const PV_D = 'mgr.site';

    const BE_COLS = 'm.id,u.email,u.realname,m.content,m.status,m.insert_ts,m.target,m.member_id,l.title';

    /**
     * @param $query
     * @param $page
     * @param $limit
     * @param $cols
     */
    public static function limitRows($query = '', $page = 0, $limit = 10, $cols = '')
    {
        $filter = self::genQuery($query);

        $filter['ORDER'] = ['m.insert_ts' => 'DESC'];

        $join = [
            '[>]' . fStaff::fmTbl() . '(s)'  => ['m.insert_user' => 'id'],
            '[>]' . fMember::fmTbl() . '(u)' => ['m.member_id' => 'id'],
        ];

        $join['[>]' . fExhib::fmTbl('lang') . '(l)'] = ['m.parent_id' => 'parent_id', 'l.lang' => '[SV]' . Module::_lang()];
        // $join['[>]' . fWork::fmTbl('lang') . '(l)'] = ['m.parent_id' => 'parent_id', 'l.lang' => '[SV]' . Module::_lang()];

        return parent::paginate(self::fmTbl() . '(m)', $filter, $page, $limit, explode(',', self::BE_COLS), $join);
    }

    /**
     * @param $target
     * @param $parent_id
     * @param $content
     */
    public static function insert($target, $parent_id, $content)
    {
        $now   = date('Y-m-d H:i:s');
        $staff = fStaff::_current();

        $data = [
            'target'      => $target,
            'parent_id'   => $parent_id,
            'member_id'   => fMember::_CMember(),
            'content'     => $content,
            'status'      => self::ST_ON,
            'last_ts'     => $now,
            'last_user'   => $staff,
            'insert_ts'   => $now,
            'insert_user' => $staff,
        ];

        mh()->insert(self::fmTbl(), $data);

        return self::chkErr(mh()->id());
    }
}
