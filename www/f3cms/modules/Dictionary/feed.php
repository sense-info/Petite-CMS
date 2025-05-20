<?php
namespace F3CMS;

/**
 * data feed
 */
class fDictionary extends Feed
{
    const MTB = 'dictionary';
    const ST_ON = 'Enabled';
    const ST_OFF = 'Disabled';

    public const BE_COLS = 'm.id,l.title,m.status,m.slug,m.cover,m.last_ts';

    /**
     * @return mixed
     */
    public static function getAll()
    {
        $result = self::exec('SELECT a.id, a.title, a.last_ts, a.status, a.slug FROM `' . self::fmTbl() . '` a ');

        return $result;
    }
}
