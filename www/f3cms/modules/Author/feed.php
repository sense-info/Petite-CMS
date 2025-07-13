<?php

namespace F3CMS;

/**
 * data feed
 */
class fAuthor extends Feed
{
    const MTB    = 'author';
    const ST_ON  = 'Enabled';
    const ST_OFF = 'Disabled';

    const PV_R = 'mgr.cms';
    const PV_U = 'mgr.cms';
    const PV_D = 'mgr.cms';

    const BE_COLS = 'm.id,l.title,m.status,m.slug,l.jobtitle,l.slogan,l.summary,m.cover,m.last_ts';

    public static function genJoin()
    {
        return [
            '[>]' . fStaff::fmTbl() . '(s)'     => ['m.insert_user' => 'id'],
            '[>]' . self::fmTbl('lang') . '(l)' => ['m.id' => 'parent_id', 'l.lang' => '[SV]' . Module::_lang()],
        ];
    }

    public static function genOrder()
    {
        return ['m.sorter' => 'ASC', 'm.insert_ts' => 'DESC'];
    }
}
