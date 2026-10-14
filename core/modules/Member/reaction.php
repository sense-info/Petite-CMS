<?php

namespace F3CMS;

class rMember extends Reaction
{
    const RTN_MISSCOLS   = 'MissCols';
    const RTN_WRONGDATA  = 'WrongData';
    const RTN_UNVERIFIED = 'UnVerified';
    const RTN_NOTSAME    = 'NotSame';
    const RTN_LOGINED    = 'Logined';
    const RTN_NEEDLOGIN  = 'NeedLogin';
    const RTN_DONE       = 'Done';
    const RTN_UPDATED    = 'Updated';
    const RTN_RESET      = 'Reset';
    const RTN_SENT       = 'Sent';

    /**
     * @param $f3
     * @param $args
     */
    public function do_login($f3, $args)
    {
        $rtn = self::RTN_LOGINED;

        $req = parent::_getReq();

        Validation::return($req, kMember::rule('login'));

        if (self::RTN_LOGINED == $rtn) {
            $cu = fMember::one($req['account'], 'm.account');

            if (null == $cu) {
                $rtn = self::RTN_WRONGDATA;
            } else {
                if (!fMember::_chkPsw($req['passwd'], $cu['pwd'])) {
                    $rtn = self::RTN_WRONGDATA;
                }

                if (fMember::ST_FREEZE == $cu['status']) {
                    $rtn = self::RTN_UNVERIFIED;
                }
            }
        }

        $result = [
            'msg'  => self::get_msgs()[$rtn]['msg'],
            'seed' => fMember::_setPsw($req['passwd']),
        ];

        if (self::RTN_LOGINED == $rtn) {
            fMember::_setCurrent($cu['account'], $cu['id'], $cu['avatar'], $cu['nickname'], $cu['realname'], $cu['intro']);
            $result['redirect'] = getCookie('login_from');
            if (empty($result['redirect'])) {
                $result['redirect'] = f3()->get('uri') . '/home';
            } else {
                $result['redirect'] = 'COOKIE';
            }
        }

        return parent::_return(self::get_msgs()[$rtn]['code'], $result);
    }

    /**
     * @param $f3
     * @param $args
     */
    public function do_reset($f3, $args)
    {
        $rtn = self::RTN_RESET;

        $req = parent::_getReq();

        Validation::return($req, kMember::rule('reset_passwd'));

        if ($req['re_passwd'] != $req['passwd']) {
            $rtn = self::RTN_NOTSAME;
        }

        if (!kMember::_isLogin()) { // only for  verify page
            $rtn = self::RTN_NEEDLOGIN;
        }

        $result = [
            'msg' => self::get_msgs()[$rtn]['msg'],
        ];

        if (self::RTN_RESET == $rtn) {
            $pid = fMember::_CMember();
            $cu  = fMember::one($pid);

            if (fMember::ST_NEW == $cu['status']) {
                fMember::changeStatus($pid, fMember::ST_VERIFIED);
            }

            fMember::saveCol([
                'col' => 'pwd',
                'val' => fMember::_setPsw($req['passwd']),
                'pid' => $pid,
            ]);

            fMember::saveCol([
                'col' => 'verify_code',
                'val' => '',
                'pid' => $pid,
            ]);

            $result['redirect'] = f3()->get('uri') . '/home';
        }

        return parent::_return(self::get_msgs()[$rtn]['code'], $result);
    }

    /**
     * @param $f3
     * @param $args
     */
    public function do_send($f3, $args)
    {
        kMember::_chkLogin();

        $rtn = self::RTN_SENT;
        $req = parent::_getReq();

        // if (empty($req['account'])) {
        //     $rtn = self::RTN_MISSCOLS;
        // }

        if (self::RTN_SENT == $rtn) {
            // $cu = fMember::one($req['account'], 'm.account');
            $cu = fMember::mine();

            if (null == $cu) {
                $rtn = self::RTN_WRONGDATA;
            } else {
                if (fMember::ST_FREEZE == $cu['status']) {
                    $rtn = self::RTN_UNVERIFIED;
                }
            }
        }

        $result = [
            'msg' => self::get_msgs()[$rtn]['msg'],
        ];

        if (self::RTN_SENT == $rtn) {
            $verify_code = fMember::renderUniqueNo(32);

            fMember::saveCol([
                'col' => 'verify_code',
                'val' => $verify_code,
                'pid' => $cu['id'],
            ]);

            f3()->set('verify_code', $verify_code);
            f3()->set('email', $cu['email']);
            f3()->set('realname', $cu['realname']);
            f3()->set('opts', fOption::load('', 'Preload'));

            $sent = Sender::mail(f3()->get('site_title') . '-信箱驗證信', Sender::renderBody('verify'), $cu['email']);
            // $result['redirect'] = f3()->get('uri') . '/member/login';
        }

        return parent::_return(self::get_msgs()[$rtn]['code'], $result);
    }

    /**
     * @param $f3
     * @param $args
     */
    public function do_ask2Change($f3, $args)
    {
        kMember::_chkLogin();
        $req = parent::_getReq();
        $rtn = self::RTN_RESET;

        if (self::RTN_RESET == $rtn) {
            $cu = fMember::_CMember('*');

            if (null == $cu) {
                $rtn = self::RTN_WRONGDATA;
            }
        }

        $result = [
            'msg' => self::get_msgs()[$rtn]['msg'],
        ];

        if (self::RTN_RESET == $rtn) {
            $verify_code = fMember::renderUniqueNo(32);

            fMember::saveCol([
                'col' => 'verify_code',
                'val' => $verify_code,
                'pid' => $cu['id'],
            ]);

            f3()->set('verify_code', $verify_code);
            f3()->set('email', $cu['account']);
            f3()->set('nickname', $cu['nickname']);
            f3()->set('opts', fOption::load('', 'Preload'));

            $sent = Sender::mail(f3()->get('site_title') . '-重設密碼通知信', Sender::renderBody('passwd'), $cu['email']);
            // $result['redirect'] = f3()->get('uri') . '/member/login';
        }

        return parent::_return(self::get_msgs()[$rtn]['code'], $result);
    }

    /**
     * @param $f3
     * @param $args
     */
    public function do_update($f3, $args)
    {
        kMember::_chkLogin();

        $rtn = self::RTN_UPDATED;

        $req = parent::_getReq();

        Validation::return($req, kMember::rule('update'));

        if (!empty($req['passwd'])) {
            if ($req['re_passwd'] != $req['passwd']) {
                $rtn = self::RTN_NOTSAME;
            }
        }

        if (empty($req['subscribed'])) {
            $req['subscribed'] = 'No';
        }

        if (self::RTN_UPDATED == $rtn) {
            $cu = fMember::mine();

            if (null == $cu) {
                $rtn = self::RTN_WRONGDATA;
            } else {
                if (fMember::ST_FREEZE == $cu['status']) {
                    $rtn = self::RTN_UNVERIFIED;
                }
            }
        }

        $result = [
            'msg' => self::get_msgs()[$rtn]['msg'],
        ];

        if (self::RTN_UPDATED == $rtn) {
            fMember::setProfile($req);

            if (!empty($req['passwd'])) {
                fMember::saveCol([
                    'col' => 'pwd',
                    'val' => fMember::_setPsw($req['passwd']),
                    'pid' => $cu['id'],
                ]);
            }

            if ($cu['email'] != $req['email']) {
                fMember::changeStatus($cu['id'], fMember::ST_NEW);
                $result['needVerify'] = 1;
            }

            $cu = fMember::mine();
            fMember::_setCurrent($cu['account'], $cu['id'], $cu['avatar'], $cu['nickname'], $cu['realname'], $cu['intro']);

            // $result['redirect'] = f3()->get('uri') . '/home';
        }

        return parent::_return(self::get_msgs()[$rtn]['code'], $result);
    }

    /**
     * @param $f3
     * @param $args
     */
    public function do_logout($f3, $args)
    {
        if (kMember::_isLogin()) {
            fMember::_clearCurrent();
        }

        return parent::_return(!kMember::_isLogin(), ['redirect' => '/']);
    }

    /**
     * @param $f3
     * @param $args
     */
    public function do_disconnect($f3, $args)
    {
        kMember::_chkLogin();

        $rtn = [];
        $req = parent::_getReq();

        if ('facebook' == $req['type'] || 'google' == $req['type']) {
            fMember::disconnect($req['type']);
        }

        if (empty(fMember::mineSns())) {
            $rtn['redirect'] = f3()->get('uri') . '/';
        }

        return parent::_return(1, $rtn); // 'uri' => f3()->get('uri') . '/member/login'
    }

    /**
     * @param $f3
     * @param $args
     */
    public function do_status($f3, $args)
    {
        return parent::_return(1, kMember::status(parent::_getReq()));
    }

    /**
     * @param $f3
     * @param $args
     */
    public function do_tokenVerify($f3, $args)
    {
        $rtn    = self::RTN_LOGINED;
        $result = [];
        $req    = parent::_getReq();
        Validation::return($req, kMember::rule('tokenVerify'));

        // get user info from SNS by SNS's token
        $data = Oauth::byToken($req['way'], $req['token']);

        if (null == $data || isset($data['error'])) {
            $rtn = self::RTN_WRONGTOKEN;
        } else {
            $cu                  = kMember::loginFromSns($data);
            $result['user']      = fMember::_CMember('*');
            $result['isLogined'] = 1;

            if (1 == $cu['need2confirm']) {
                $result['redirect'] = f3()->get('uri') . '/member/confirm';
            } else {
                $result['redirect'] = 'reload';
            }
        }

        $result['msg'] = self::get_msgs()[$rtn]['msg'];

        return parent::_return(self::get_msgs()[$rtn]['code'], $result);
    }

    /**
     * @param $f3
     * @param $args
     */
    public function do_tokenAuth($f3, $args)
    {
        return parent::_return(1, kMember::status(parent::_getReq()));
    }

    /**
     * @param $f3
     * @param $args
     */
    public function do_resend($f3, $args)
    {
        chkAuth(fMember::PV_R);
        $req = parent::_getReq();

        if (!isset($req['id'])) {
            return self::_return(8004);
        }

        $cu = fMember::one($req['id']);

        if (empty($cu)) {
            return self::_return(8004);
        }

        $verify_code = fMember::renderUniqueNo(32);

        kMember::sendInvite($cu['email'], $verify_code);

        fMember::saveCol([
            'col' => 'verify_code',
            'val' => $verify_code,
            'pid' => $cu['id'],
        ]);

        return parent::_return(1, $rtn);
    }

    /**
     * @param $f3
     * @param $args
     */
    public function do_list($f3, $args)
    {
        chkAuth(fMember::PV_R); // kStaff::_chkLogin();

        $req = parent::_getReq();

        $req['page']  = (isset($req['page'])) ? ($req['page'] - 1) : 0;
        $req['limit'] = (!empty($req['limit'])) ? max(min($req['limit'] * 1, 24), 3) : 12;

        $req['query'] = (!isset($req['query'])) ? '' : $req['query'];

        $rtn = fMember::limitRows($req['query'], $req['page'], $req['limit']);

        $super  = canDo(fMember::PV_SDP);
        $normal = canDo(fMember::PV_R);

        foreach ($rtn['subset'] as &$row) {
            $row['sudo'] = 0;
            if ($super || ($normal && fStaff::_current('email') == $row['email'])) {
                $row['sudo'] = 1;
            }
        }

        return self::_return(1, $rtn);
    }

    /**
     * save photo
     *
     * @param object $f3   - $f3
     * @param array  $args - uri params
     */
    public function do_upload_avatar($f3, $args)
    {
        kMember::_chkLogin();
        $req = parent::_getReq();

        $files = f3()->get('FILES');

        if (in_array($files['photo']['type'], f3()->get('photo_acceptable'))) {
            [$filename, $width, $height] = Upload::savePhoto($files, [
                f3()->get('default_thn'),
                f3()->get('all_thn'),
            ], 'photo');
        } else {
            return parent::_return(8002, ['msg' => '檔案格式不合!!']);
        }

        $cu = fMember::_CMember('*');

        fMember::saveCol([
            'col' => 'avatar',
            'val' => $filename,
            'pid' => $cu['id'],
        ]);

        fMember::_setCurrent($cu['account'], $cu['id'], $filename, $cu['nickname'], $cu['realname'], $cu['intro']);

        return self::_return(1, [
            'filename' => $filename,
        ]);
    }

    // DEPRECATED: no this flow
    /**
     * @param $f3
     * @param $args
     */
    public function do_add_new($f3, $args)
    {
        $rtn = self::RTN_DONE;

        $req = parent::_getReq();

        if (empty($req['account'])) {
            $rtn = self::RTN_MISSCOLS;
        }

        if (empty($req['passwd'])) {
            $rtn = self::RTN_MISSCOLS;
        }

        if (empty($req['subscribed'])) {
            $req['subscribed'] = 'No';
        }

        $cu  = fMember::one($req['account'], 'm.account');

        if (null != $cu) {
            $rtn = self::RTN_WRONGDATA;
        } else {
            kMember::addMember($req);
        }

        $result = [
            'msg' => self::get_msgs()[$rtn]['msg'],
        ];

        if (self::RTN_DONE == $rtn) {
            $result['redirect'] = f3()->get('uri') . '/home';
        }

        return parent::_return(self::get_msgs()[$rtn]['code'], $result);
    }

    /**
     * save whole form for backend
     *
     * @param object $f3   - $f3
     * @param array  $args - uri params
     */
    public function do_save($f3, $args)
    {
        kStaff::_chkLogin(); // chkAuth(fMember::PV_U);
        $req = parent::_getReq();

        if (!isset($req['id'])) {
            return self::_return(8004);
        }

        if (empty($req['id'])) {
            $cu  = fMember::one($req['email'], 'm.account');

            if (null != $cu) {
                return self::_return(8004, ['msg' => '帳號重覆']);
            } else {
                $id = kMember::addMember([
                    'account' => $req['email'],
                    'passwd'  => fMember::renderUniqueNo(8),
                    'level'   => 'KOL',
                ]);
            }
        } else {
            $id = fMember::save($req);
        }

        return self::_return(1, ['id' => $id]);
    }

    public static function get_msgs()
    {
        return [
            'Done'       => [
                'code' => '1',
                'msg'  => '歡迎您加入!',
            ],
            'Logined'    => [
                'code' => '1',
                'msg'  => '歡迎您回來!',
            ],
            'NeedLogin'  => [
                'code' => '8201',
                'msg'  => '尚未登入!',
            ],
            'Updated'    => [
                'code' => '1',
                'msg'  => '變更已完成!',
            ],
            'Reset'      => [
                'code' => '1',
                'msg'  => '已重設密碼!',
            ],
            'Sent'      => [
                'code' => '1',
                'msg'  => '已寄出驗證信，請收信確認!',
            ],
            'MissCols'   => [
                'code' => '8002',
                'msg'  => '欄位未填寫，請重新確認!',
            ],
            'WrongData'  => [
                'code' => '8204',
                'msg'  => 'Email 或密碼有誤，請重新確認!',
            ],
            'UnVerified' => [
                'code' => '8205',
                'msg'  => '您尚未完成 Email 認證',
            ],
            'NotSame'    => [
                'code' => '8206',
                'msg'  => '二次密碼不符，請重新確認!',
            ],
        ];
    }

    /**
     * @param $f3
     * @param $args
     */
    public function do_get_one($f3, $args)
    {
        kStaff::_chkLogin(); // chkAuth(fMember::PV_U);
        // kMember::_chkLogin();

        $req = parent::_getReq();

        if (!isset($req['pid'])) {
            return parent::_return(8004);
        }

        if (0 == $req['pid']) {
            return parent::_return(1, ['id' => 0]);
        }

        $cu = fMember::one($req['pid']);

        if (null == $cu) {
            return parent::_return(7100);
        }

        unset($cu['pwd']);

        return parent::_return(1, $cu);
    }

    /**
     * @param $f3
     * @param $args
     */
    public function do_mine($f3, $args)
    {
        kMember::_chkLogin();

        $req = parent::_getReq();

        $cu = fMember::mine();

        if (null == $cu) {
            return parent::_return(7100);
        }

        return parent::_return(1, $cu);
    }
}
