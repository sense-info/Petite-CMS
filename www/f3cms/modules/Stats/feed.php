<?php

namespace F3CMS;

/**
 * data feed
 */
class fStats extends Feed
{
    const MTB       = 'stats';
    const MULTILANG = 0;

    const BE_COLS = 'm.uid,m.insert_ts,m.sid,m.spent';

    /**
     * @param $queryStr
     *
     * @return mixed
     */
    public static function _handleQuery($queryStr = '')
    {
        $query = parent::_handleQuery($queryStr);
        $new   = [];

        foreach ($query as $key => $value) {
            if ('insert_ts' == $key && 'today' == $value) {
                $new[$key . '[<>]'] = [date('Y-m-d') . ' 00:00:00', date('Y-m-d') . ' 23:59:59'];
            } else {
                $new[$key] = $value;
            }
        }

        return $new;
    }

    /**
     * @param $mode
     *
     * @return mixed
     */
    public static function stat($sid, $start, $end, $mode = 'weekly')
    {
        $type   = ucfirst($mode);
        $method = 'get' . $type . 'Stat';
        $return = [];

        if (method_exists(__CLASS__, $method)) {
            $return = call_user_func('self::' . $method, $sid, $start, $end);
        }

        return $return;
    }

    /**
     * @param $sid
     * @param $start
     * @param $end
     */
    public static function getHourlyStat($sid, $start, $end)
    {
        return self::exec('SELECT FROM_UNIXTIME(`ts`) AS `time`, SUM(`spent`) AS `spent` FROM `' . self::fmTbl('hourly') . '` WHERE ' . fTrack::filterSid($sid) . ' AND `ts` BETWEEN :start AND :end GROUP BY `ts`', [':start' => $start, ':end' => $end]);
    }

    /**
     * @param $sid
     * @param $start
     * @param $end
     */
    public static function getDailyStat($sid, $start, $end)
    {
        return self::exec('SELECT FROM_UNIXTIME(`ts`) AS `time`, SUM(`spent`) AS `spent` FROM `' . self::fmTbl('daily') . '` WHERE ' . fTrack::filterSid($sid) . ' AND `ts` BETWEEN :start AND :end GROUP BY `ts`', [':start' => $start, ':end' => $end]);
    }

    /**
     * @param $sid
     * @param $start
     * @param $end
     */
    public static function getMonthlyStat($sid, $start, $end)
    {
        return self::exec('SELECT FROM_UNIXTIME(`ts`) AS `time`, SUM(`spent`) AS `spent` FROM `' . self::fmTbl('monthly') . '` WHERE ' . fTrack::filterSid($sid) . ' AND `ts` BETWEEN :start AND :end GROUP BY `ts`', [':start' => $start, ':end' => $end]);
    }

    public static function insertHourly()
    {
        mh(true)->info();

        $ts = strtotime(date('Y-m-d H:00:00')) - 1;
        // $res = fTrack::getHourlyStat($ts - 3599, $ts);
        self::exec('set sql_mode =\'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION\'; ');

        self::exec(self::_renderQuery('hourly'), [':start' => ($ts - 3599), ':end' => $ts]);
    }

    public static function insertDaily()
    {
        mh(true)->info();

        $ts = strtotime(date('Y-m-d 00:00:00')) - 1;
        // $res = fTrack::getDailyStat($ts - 86399, $ts);
        self::exec('set sql_mode =\'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION\'; ');

        self::exec(self::_renderQuery('daily'), [':start' => ($ts - 86399), ':end' => $ts]);
    }

    public static function insertMonthly()
    {
        mh(true)->info();

        $endTs   = strtotime(date('Y-m-01 00:00:00')) - 1;
        $startTs = strtotime(date('Y-m-01 00:00:00', $endTs));
        // $res = fTrack::getDailyStat($startTs, $endTs);
        self::exec('set sql_mode =\'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION\'; ');

        self::exec(self::_renderQuery('monthly'), [':start' => $startTs, ':end' => $endTs]);
    }

    /**
     * @param $subTbl
     */
    private static function _renderQuery($subTbl = 'hourly')
    {
        switch ($subTbl) {
            case 'daily':
                $dateformat = '%Y-%m-%d 00:00:00';
                break;
            case 'monthly':
                $dateformat = '%Y-%m-01 00:00:00';
                break;
            default:
                $dateformat = '%Y-%m-%d %H:00:00';
                break;
        }

        return 'INSERT INTO `' . self::fmTbl($subTbl) . '`(`uid`, `insert_ts`, `sid`, `cid`, `mid`, `oid`, `ts`, `spent`)
            SELECT CONCAT(date_format(`ts`,\'%y%m%d%H\'), \'-\', `mid`, \'-\', `sid`) as `uid`, CURRENT_TIMESTAMP, `sid`, `cid`, `mid`, `oid`
            , date_format(`ts`,\'' . $dateformat . '\') as `new_ts`, SUM(t.`spent`) AS `spent`
            FROM `' . fTrack::fmTbl() . '` t
            WHERE `ts` BETWEEN :start AND :end GROUP BY `new_ts`, `mid`, `sid`; ';
    }
}
