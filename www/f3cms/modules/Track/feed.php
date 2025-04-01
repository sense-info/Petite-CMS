<?php

namespace F3CMS;

/**
 * data feed
 */
class fTrack extends Feed
{
    const MTB       = 'track';
    const MULTILANG = 0;
    const PK_COL    = 'uid';

    const PV_R = 'mgr.site';
    const PV_U = 'mgr.site';
    const PV_D = 'mgr.site';

    const BE_COLS = 'm.ts,c.title(video),m.vid,m.mid,m.spent,m.pos,s.realname,s.email';

    /**
     * @param $req
     */
    public static function insert($req)
    {
        self::chkErr(mh()->insert(self::fmTbl(), $req));

        return mh()->id();
    }

    /**
     * @param $mode
     *
     * @return mixed
     */
    public static function stat($pid, $mode = 'weekly')
    {
        $type   = ucfirst($mode);
        $method = 'get' . $type . 'Stat';
        $return = [];

        if (method_exists(__CLASS__, $method)) {
            $return = call_user_func('self::' . $method, $pid);
        }

        return $return;
    }

    /**
     * @param $pid
     */
    public static function getLastStat($pid)
    {
        return self::exec('SELECT FROM_UNIXTIME(`ts`) AS `time`, `spent` FROM `' . self::fmTbl() . '` WHERE 1 ' . self::filterPid($pid) . ' ORDER BY `ts` DESC', [], true);
    }

    /**
     * @param $pid
     */
    public static function getLastStatByMid($pid, $range = 5)
    {
        return self::exec('SELECT `mid`, MAX(`ts`) AS `last` FROM `' . self::fmTbl() . '` WHERE 1 ' . self::filterPid($pid) . ' AND `ts` > :ts GROUP BY `mid`', [':ts' => date('Y-m-d H:i:s', strtotime('-' . $range . ' minutes'))]);
    }

    /**
     * @param $pid
     * @param $ts
     */
    public static function getTsStat($pid, $ts)
    {
        return self::exec('SELECT FROM_UNIXTIME(MAX(`ts`)) AS `time`, SUM(`spent`) AS `spent` FROM `' . self::fmTbl() . '` WHERE 1 ' . self::filterPid($pid) . ' AND `ts` = :ts ', [':ts' => $ts], true);
    }

    public static function chkStat($ts = 0, $tbl = 'hourly')
    {
        if ('hourly' == $tbl) {
            $last = mh()->get(self::fmTbl($tbl), '*', [
                'min_ts[<>]' => [
                    date('Y-m-d H:00:00', $ts - 3600),
                    date('Y-m-d H:00:00', $ts),
                ],
                'ORDER' => ['min_ts' => 'DESC'],
            ]);
        } else {
            $last = mh()->get(self::fmTbl($tbl), '*', [
                'min_ts[<>]' => [
                    date('Y-m-d 00:00:00', $ts - 86400),
                    date('Y-m-d 00:00:00', $ts),
                ],
                'ORDER' => ['min_ts' => 'DESC'],
            ]);
        }

        return empty($last) ? [] : $last;
    }

    /**
     * @param $ts
     */
    public static function insertHourlyStat($ts = 0)
    {
        mh(true); // for pcntl mode
        self::exec('set sql_mode =\'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION\'; ');

        if (0 == $ts) {
            $ts = time();
        }

        $ts = intval($ts);

        self::exec('CALL outputHourlyStats(:start, :end);', [':start' => date('Y-m-d H:00:00', $ts - 3600), ':end' => date('Y-m-d H:00:00', $ts)]);
    }

    /**
     * @param $ts
     */
    public static function insertDailyStat($ts = 0)
    {
        mh(true); // for pcntl mode
        self::exec('set sql_mode =\'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION\'; ');

        if (0 == $ts) {
            $ts = time();
        }

        $ts = intval($ts);

        self::exec('CALL outputDailyStats(:start, :end);', [':start' => date('Y-m-d 00:00:00', $ts - 86400), ':end' => date('Y-m-d 00:00:00', $ts)]);
    }

    /**
     * @param $query
     * @param $page
     * @param $limit
     *
     * @return mixed
     */
    public static function limitRows($query = '', $page = 0, $limit = 12, $cols = '')
    {
        $filter = self::genFilter($query);

        $filter['ORDER'] = self::genOrder();

        $cols             = explode(',', self::BE_COLS);
        $cols['realname'] = MHelper::raw('hideCName(s.<realname>)');
        $cols['email']    = MHelper::raw('hideEmail(s.<email>)');

        return self::paginate(self::fmTbl() . '(m)', $filter, $page, $limit, $cols, self::genJoin());
    }

    /**
     * @param $query
     * @param $page
     * @param $limit
     * @param $cols
     *
     * @return mixed
     */
    public static function hourlyStatRows($query = '', $page = 0, $limit = 12, $cols = '')
    {
        $filter = self::genFilter($query);

        $filter['ORDER'] = ['m.min_ts' => 'DESC'];

        return self::paginate(self::fmTbl('hourly') . '(m)', $filter, $page, $limit, [
            'm.min_ts', 'm.max_ts', 'c.title(video)', 'm.vid', 'm.mid', 'm.spent', 'm.pos', 's.realname', 's.email',
        ], self::genJoin());
    }

    /**
     * @param $query
     * @param $page
     * @param $limit
     * @param $cols
     *
     * @return mixed
     */
    public static function dailyStatRows($query = '', $page = 0, $limit = 12, $cols = '')
    {
        $filter = self::genFilter($query);

        $filter['ORDER'] = ['m.min_ts' => 'DESC'];

        return self::paginate(self::fmTbl('daily') . '(m)', $filter, $page, $limit, [
            'm.min_ts', 'm.max_ts', 'c.title(video)', 'm.vid', 'm.mid', 'm.spent', 'm.pos', 's.realname', 's.email',
        ], self::genJoin());
    }

    public static function genJoin()
    {
        return [
            '[><]' . fVideo::fmTbl('lang') . '(c)'      => ['m.vid' => 'parent_id', 'c.lang' => '[SV]' . Module::_lang()],
            '[>]' . fMember::fmTbl() . '(s)'            => ['m.mid' => 'id'],
        ];
    }

    public static function genOrder()
    {
        return ['m.ts' => 'DESC'];
    }

    /**
     * @param $pid
     */
    public static function filterPid($pid)
    {
        $condition = '';
        preg_match_all('/([mov])-(\d+),?/i', $pid, $match);

        if (count($match[0]) > 0) {
            for ($i=0; $i < count($match[0]); ++$i) {
                $condition .= ' AND `' . $match[1][$i] . 'id` = ' . $match[2][$i] . ' ';
            }
        }

        return $condition;
    }

    /**
     * @param $format
     */
    private static function _renderQuery($format, $pid)
    {
        switch ($format) {
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

        return 'SELECT SUM(`spent`) AS `spent`,
                date_format(`ts`,\'' . $dateformat . '\') as `time`
            FROM `' . self::fmTbl() . '`
            WHERE (`ts` BETWEEN :start AND :end) ' . self::filterPid($pid) . ' GROUP BY `time` ';
    }
}
