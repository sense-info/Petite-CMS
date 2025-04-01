<?php

namespace F3CMS;

/**
 * data feed
 */
class fMember extends Feed
{
    const MTB         = 'member';
    const ST_NEW      = 'New';
    const ST_VERIFIED = 'Verified';
    const ST_FREEZE   = 'Invalid';

    const MULTILANG = 0;

    const PV_R = 'base.member';
    const PV_U = 'mgr.member';
    const PV_D = 'mgr.member';

    const PV_SDP = 'mgr.member';

    const BE_COLS = 'm.id,m.status,m.realname,m.intro,m.avatar,m.account,m.level,m.email,m.last_ts';

    /**
     * @param $query
     * @param $page
     * @param $limit
     *
     * @return mixed
     */
    public static function limitRows($query = '', $page = 0, $limit = 12, $cols = '')
    {
        $filter = self::genQuery($query);

        // $filter['a.lang'] = Module::_lang();

        $filter['ORDER'] = ['m.insert_ts' => 'DESC'];

        $join = [];

        if (!canDo(self::PV_SDP)) {
            $filter['m.email'] = fStaff::_current('email');
        }

        return self::paginate(self::fmTbl() . '(m)', $filter, $page, $limit, explode(',', self::BE_COLS), $join);
    }

    /**
     * @param $req
     */
    public static function insert($req)
    {
        $now = date('Y-m-d H:i:s');

        if (empty($req['level'])) {
            $req['level'] = 'Normal';
        }

        mh()->insert(self::fmTbl(), [
            'status'      => self::ST_NEW,
            'email'       => $req['email'],
            'account'     => $req['email'],
            'level'       => $req['level'],
            'nickname'    => $req['nickname'],
            'verify_code' => $req['verify_code'],
            'pwd'         => $req['pwd'],
            'last_ts'     => $now,
            'insert_ts'   => $now,
            'insert_user' => fStaff::_current('id'),
        ]);

        return self::chkErr(mh()->id());
    }

    /**
     * @param $req
     */
    public static function insertSns($req)
    {
        $now = date('Y-m-d H:i:s');

        mh()->insert(self::fmTbl('sns'), [
            'member_id'   => $req['member_id'],
            'sns_id'      => $req['sns_id'],
            'source'      => $req['source'],
            'email'       => $req['email'],
            'name'        => $req['name'],
            'last_ts'     => $now,
            'insert_ts'   => $now,
            'insert_user' => fStaff::_current('id'),
        ]);

        return mh()->id();
    }

    /**
     * @param $req
     */
    public static function setProfile($req)
    {
        $rtn = mh()->update(self::fmTbl(), [
            'realname' => $req['realname'],
            // 'nickname' => $req['nickname'],
            'mobile'   => $req['mobile'],
            'email'    => $req['email'],
            'gender'   => $req['gender'],
            'birth'    => $req['birth'],
            'intro'    => $req['intro'],
            'located'  => $req['located'],
            'last_ts'  => date('Y-m-d H:i:s'),
        ], [
            'id' => self::_CMember(),
        ]);

        return self::chkErr($rtn->rowCount());
    }

    /**
     * @param $id
     * @param $days
     */
    public static function renewExpired($id, $days = 0)
    {
        if (0 == $days) {
            $days = f3()->get('token_expired');
        }

        mh()->update(self::fmTbl(), [
            'expired_ts' => date('Y-m-d H:i:s', time() + 86400 * $days),
        ], [
            'id'       => $id,
            'token[!]' => null,
        ]);
    }

    /**
     * @param $id
     *
     * @return mixed
     */
    public static function renewToken($id)
    {
        $token = self::_genToken();
        $rtn   = mh()->update(self::fmTbl(), [
            'token'      => $token,
            'expired_ts' => date('Y-m-d H:i:s', time() + 86400 * f3()->get('token_expired')),
        ], [
            'id' => $id,
        ]);

        safeCookie('mobile_token', $token);

        return $token;
    }

    /**
     * @return mixed
     */
    public static function one($val, $col = 'm.id', $condition = [], $multilang = 1)
    {
        $filter = array_merge([
            $col    => $val,
            'ORDER' => [$col => 'DESC'],
        ], $condition);

        $cu = mh()->get(self::fmTbl() . '(m)', [
            'm.id', 'm.status', 'm.pwd', 'm.account', 'm.nickname', 'm.subscribed', 'm.avatar', 'm.birth', 'm.gender', 'm.located', 'm.email', 'm.mobile', 'm.realname', 'm.info', 'm.intro', 'm.level', 'm.expired_ts',
        ], $filter);

        return $cu;
    }

    /**
     * @param $sns_id
     * @param $source
     *
     * @return mixed
     */
    public static function oneSns($sns_id, $source)
    {
        $data = mh()->get(self::fmTbl('sns'), '*', [
            'sns_id' => $sns_id,
            'source' => $source,
            'ORDER'  => ['id' => 'DESC'],
        ]);

        if (empty($data)) {
            return null;
        } else {
            return $data;
        }
    }

    /**
     * @return mixed
     */
    public static function mine($member_id = 0)
    {
        $member_id = (0 == $member_id) ? self::_CMember() : $member_id;

        $cu = self::one($member_id);
        if (!empty($cu)) {
            $cu['sns'] = self::mineSns($member_id);
            unset($cu['pwd']);
        }

        return $cu;
    }

    /**
     * @param $sns_id
     * @param $source
     *
     * @return mixed
     */
    public static function mineSns($member_id = 0)
    {
        $data = mh()->select(self::fmTbl('sns'), ['source', 'email', 'insert_ts', 'sns_id'], [
            'member_id' => (0 == $member_id) ? self::_CMember() : $member_id,
        ]);

        if (empty($data)) {
            return null;
        } else {
            return $data;
        }
    }

    /**
     * @param $type
     * @param $member_id
     */
    public static function disconnect($type, $member_id = 0)
    {
        $member_id = (0 == $member_id) ? self::_CMember() : $member_id;
        mh()->delete(self::fmTbl('sns'), [
            'member_id' => $member_id,
            'source'    => $type,
        ]);
    }

    /**
     * @param $member_id
     */
    public static function addEnrolled($member_id = 0)
    {
        mh()->update(self::fmTbl('stats'), [
            'enrolled[+]' => 1,
        ], [
            'member_id' => $member_id,
        ]);
    }

    /**
     * @param $member_id
     */
    public static function addFinished($member_id = 0)
    {
        mh()->update(self::fmTbl('stats'), [
            'finished[+]' => 1,
        ], [
            'member_id' => $member_id,
        ]);
    }

    /**
     * @param $query
     */
    public static function getOpts($query = '', $column = 'title')
    {
        $filter = ['LIMIT' => 100];

        if ('' != $query) {
            $filter['OR']['nickname[~]'] = $query;
            $filter['OR']['realname[~]'] = $query;
        }

        $opts = mh()->select(self::fmTbl(''), [
            'id',
            'title' => MHelper::raw('CONCAT(COALESCE(<realname>, \'\'), \'(\', COALESCE(<nickname>, \'\'), \')\')'),
        ], $filter);

        return $opts;
    }

    /**
     * @return mixed
     */
    public static function oneOpt($pid)
    {
        $filter = [
            'id'    => $pid,
            'ORDER' => ['id' => 'DESC'],
        ];

        $cu = mh()->get(self::fmTbl(), [
            'id',
            'title' => MHelper::raw('CONCAT(COALESCE(<realname>, \'\'), \'(\', COALESCE(<nickname>, \'\'), \')\')'),
        ], $filter);

        return $cu;
    }

    public static function renewStats()
    {
        mh(true)->info();

        self::exec('set sql_mode =\'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION\'; ');

        self::exec('REPLACE INTO `' . self::fmTbl('stats') . '` (`member_id`, `spent`) SELECT `mid`, SUM(`spent`) AS `spent` FROM `' . fTrack::fmTbl() . '` WHERE `mid` != 0 GROUP BY `mid`');

        self::exec('REPLACE INTO `' . self::fmTbl('stats') . '` (`member_id`, `spent`, `enrolled`, `finished`)
            SELECT a.`member_id`, IFNULL(c.`spent`, 0), COUNT(a.`id`) AS `cnt`, COUNT(b.`certificate`) AS `cert`
                FROM `' . fEnrolled::fmTbl() . '` a
                LEFT JOIN  `' . fEnrolled::fmTbl() . '` b ON b.`id` = a.`id` AND b.`certificate` = \'Enabled\'
                LEFT JOIN  `' . self::fmTbl('stats') . '` c ON c.`member_id` = a.`member_id`
                WHERE 1 GROUP BY a.`member_id`');
    }

    public static function updateStats()
    {
        mh(true)->info();

        self::exec('set sql_mode =\'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION\'; ');

        self::exec('UPDATE `' . self::fmTbl('stats') . '` AS m
                INNER JOIN (SELECT SUM(`spent`) AS `spent`, `mid` FROM `' . fTrack::fmTbl() . '` WHERE 1 GROUP BY `mid`) AS t ON t.`mid` = m.`member_id`
            SET m.`spent` = t.`spent` WHERE 1');

        // self::exec('UPDATE `' . self::fmTbl('stats') . '` AS m
        //     INNER JOIN (SELECT a.`member_id`, COUNT(a.`id`) AS `cnt`, COUNT(b.`certificate`) AS `cert` FROM `' . fEnrolled::fmTbl() . '` a
        //         LEFT JOIN  `' . fEnrolled::fmTbl() . '` b ON b.`id` = a.`id` AND b.`certificate` = \'Enabled\'
        //         WHERE 1 GROUP BY a.`member_id`) AS t ON t.`mid` = m.`member_id`
        //     SET m.`enrolled` = t.`cnt`, m.`finished` = t.`cert` WHERE 1');
    }

    /**
     * @param $account
     * @param $id
     * @param $org_id
     * @param $role
     */
    public static function _setCurrent($account, $id, $avatar, $nickname, $realname, $intro)
    {
        f3()->set(
            'SESSION.cu_member',
            ['account' => $account, 'id' => $id, 'avatar' => $avatar, 'nickname' => $nickname, 'intro' => $intro, 'realname' => $realname, 'has_login' => 1]
        );
    }

    public static function _clearCurrent()
    {
        f3()->clear('SESSION.cu_member');
    }

    /**
     * @param $column
     *
     * @return mixed
     */
    public static function _CMember($column = 'id')
    {
        $cu = f3()->get('SESSION.cu_member');
        // $cu = [
        //     'account' => 'shuaib25@gmail.com',
        //     'id' => 1,
        //     'nickname' => '測試帳號',
        //     'avatar' => 'https://robohash.org/c4e919002494d5e124c544e99e073308?set=set4&s=64',
        //     'has_login' => 1
        // ];

        $str = '';

        if (isset($cu) && '*' != $column && isset($cu[$column])) {
            $str = $cu[$column];
        }

        return ('*' == $column) ? $cu : $str;
    }

    /**
     * @param $email
     * @param $type
     */
    public static function getGravatar($email, $type = 'kitte')
    {
        $size = 80;

        return (('avatar' === $type) ? '//www.gravatar.com/avatar/' . md5($email) . '.jpg?s=' : '//robohash.org/' . md5($email) . '?set=set4&s=') . $size;
    }
}
