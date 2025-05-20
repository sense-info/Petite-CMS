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

    const BE_COLS = 'm.id,m.title,m.slug,m.status,m.pic,info,m.last_ts';

    public static function genJoin()
    {
        return ['[>]' . fStaff::fmTbl() . '(s)' => ['m.insert_user' => 'id']];
    }
}
