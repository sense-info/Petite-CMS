<?php

namespace F3CMS;

/**
 * kit lib
 */
class kMember extends Kit
{
    /**
     * @param $email
     * @param $verify_code
     */
    public static function sendInvite($email, $verify_code)
    {
        f3()->set('verify_code', $verify_code);
        f3()->set('service_mail', fOption::get('service_mail'));
        f3()->set('email', $email);

        $tp      = \Template::instance();
        $content = $tp->render('mail/invite.html');

        Sender::sendmail(f3()->get('site_title') . ' 帳號開通通知信', $content, $email);
    }

    /**
     * @param $req
     *
     * @return mixed
     */
    public static function status($req)
    {
        $rtn = ['isLogined' => 0];

        $token = '';
        if (isset($_SERVER['HTTP_MOBILE_TOKEN'])) {
            $token = $_SERVER['HTTP_MOBILE_TOKEN'];
        } elseif (isset($req['token'])) {
            $token = $req['token'];
        }

        if ('' != $token) {
            // 無 session, login by token
            $cu = fMember::one($token, 'token');
            if (fMember::ST_FREEZE != $cu['status'] && $cu['expired_ts'] > date('Y-m-d H:i:s')) {
                $rtn['isLogined'] = 1;
                fMember::_setCurrent($cu['account'], $cu['id'], $cu['avatar'], $cu['nickname'], $cu['realname'], $cu['intro']);
            }
        }

        if (1 != $rtn['isLogined'] && self::_isLogin()) {
            $rtn['isLogined'] = 1;
        }

        if (1 == $rtn['isLogined']) {
            $cu = fMember::_CMember('*');
            if (!empty($req['force']) && '1' == $req['force']) {
                // update token
                $cu['token'] = fMember::renewToken($cu['id']);
                fMember::_setCurrent($cu['account'], $cu['id'], $cu['avatar'], $cu['nickname'], $cu['realname'], $cu['intro']);
            } else {
                fMember::renewExpired($cu['id']);
            }
            $rtn['user'] = $cu;
        }

        if (kStaff::_isLogin()) {
            $rtn['isStaff'] = 1;
        }

        return $rtn;
    }

    /**
     * @param $data
     *
     * @return mixed
     */
    public static function loginFromSns($data)
    {
        $source = strtolower($data['provider']);

        $email = trim($data['info']['email']);
        $email = (empty($email)) ? '' : $email; // $data['uid'] . '@fake.' . $source . '.com'

        $sns = fMember::oneSns($data['uid'], $source);
        if (null == $sns) {
            $sameMail = fMember::one($email, 'm.email', [], -1);
            if (null == $sameMail) {
                $cu = fMember::one($email, 'm.account', [], -1);
                if (null == $cu) {
                    $member_id = fMember::insert([
                        'pwd'         => null,
                        'verify_code' => null,
                        'email'       => $email,
                        'nickname'    => $data['info']['name'],
                    ]);
                } else {
                    $member_id = $cu['id'];
                }
            } else {
                $member_id = $sameMail['id'];
            }

            fMember::insertSns([
                'member_id' => $member_id,
                'sns_id'    => $data['uid'],
                'source'    => $source,
                'email'     => $email,
                'name'      => $data['info']['name'],
            ]);
        } else {
            $member_id = $sns['member_id'];
        }

        $cu = fMember::one($member_id);
        fMember::saveMeta($member_id, [$source . '_rtn' => json_encode($data['info'])], true); // update sns response data

        if (empty($cu['avatar']) && $cu['avatar'] != $data['info']['image']) {
            fMember::saveCol([
                'col' => 'avatar',
                'val' => $data['info']['image'],
                'pid' => $member_id,
            ]);
            $cu['avatar'] = $data['info']['image'];
        }

        if ($cu['expired_ts'] > date('Y-m-d H:i:s')) {
            fMember::renewExpired($member_id);
        } else {
            $cu['token'] = fMember::renewToken($member_id);
        }

        fMember::_setCurrent($cu['account'], $cu['id'], $cu['avatar'], $cu['nickname'], $cu['realname'], $cu['intro']);

        return $cu;
    }

    /**
     * @param $data
     *
     * @return mixed
     */
    public static function reconnectSns($data)
    {
        $renewSession = 0;
        $source       = strtolower($data['provider']);

        $email = trim($data['info']['email']);
        $email = (empty($email)) ? '' : $email; // $data['uid'] . '@fake.' . $source . '.com'

        $sns = fMember::oneSns($data['uid'], $source);

        if (null == $sns) {
            $cu = fMember::mine();

            fMember::insertSns([
                'member_id' => $cu['id'],
                'sns_id'    => $data['uid'],
                'source'    => $source,
                'email'     => $email,
                'name'      => $data['info']['name'],
            ]);

            fMember::saveMeta($cu['id'], [$source . '_rtn' => json_encode($data['info'])], true); // update sns response data

            if (empty($cu['avatar'])) {
                fMember::saveCol([
                    'col' => 'avatar',
                    'val' => $data['info']['image'],
                    'pid' => $cu['id'],
                ]);

                $cu['avatar'] = $data['info']['image'];
                $renewSession = 1;
            }

            if ('google' == $source && $email == $cu['email']) {
                fMember::changeStatus($cu['id'], fMember::ST_VERIFIED);
                $renewSession = 1;
            }

            if (1 == $renewSession) {
                fMember::_setCurrent($cu['account'], $cu['id'], $cu['avatar'], $cu['nickname'], $cu['realname'], $cu['intro']);
            }
        } else {
            $cu = [];
        }

        return $cu;
    }

    /**
     * @param $req
     *
     * @return mixed
     */
    public static function addMember($req)
    {
        $req['verify_code'] = fMember::renderUniqueNo(32);

        // TODO: verify_deadline

        $data = [
            'pwd'         => fMember::_setPsw($req['passwd']),
            'verify_code' => $req['verify_code'],
            'email'       => $req['account'],
        ];

        if (!empty($req['name'])) {
            $data['realname'] = $req['name'];
        }
        if (!empty($req['realname'])) {
            $data['realname'] = $req['realname'];
        }

        if (empty($req['avatar'])) {
            $data['avatar'] = fMember::getGravatar($req['account']);
        } else {
            $data['avatar'] = $req['avatar'];
        }

        if (!empty($req['level'])) {
            $data['level'] = $req['level'];
        }

        $pid = fMember::insert($data);

        self::sendInvite($req['account'], $req['verify_code']);

        return $pid;
    }

    public static function rules()
    {
        return [
            'login'        => [
                'account' => 'required|email|min:3|max:200', // 建議長度 8-16 字元，含英數字
                // SELECT `id`, `account`, LENGTH(`account`) AS LengthOfString FROM `tbl_member`
                //     WHERE 1 HAVING LengthOfString > 16 OR  LengthOfString < 4;
                // 526, 1062, 61, 415

                'passwd'  => 'required|min:4|max:32', // 建議長度 8-16 字元，含英數字
            ],
            'update'       => [
                // 'passwd'    => 'regex:/^(?=.*\d)(?=.*[a-zA-Z]){2,}(?=.*[a-zA-Z])(?!.*\s).{8,32}/', // 建議長度 8-16 字元，含英數字
                // 're_passwd' => 'regex:/^(?=.*\d)(?=.*[a-zA-Z]){2,}(?=.*[a-zA-Z])(?!.*\s).{8,32}/', // 建議長度 8-16 字元，含英數字

                'realname' => 'required|min:2|max:100',
                'intro'    => 'required|min:2|max:100',
                // 'nickname'  => 'required|min:2|max:100',
                'email'    => 'required|email',
                'mobile'   => 'min:10',
                'gender'   => 'required',
                'birth'    => 'before:-18 year',
            ],
            'reset_passwd' => [
                'passwd'    => 'regex:/^(?=.*\d)(?=.*[a-zA-Z]){2,}(?=.*[a-zA-Z])(?!.*\s).{8,32}/', // 建議長度 8-16 字元，含英數字
                're_passwd' => 'regex:/^(?=.*\d)(?=.*[a-zA-Z]){2,}(?=.*[a-zA-Z])(?!.*\s).{8,32}/', // 建議長度 8-16 字元，含英數字
            ],
            'tokenVerify'  => [
                'token' => 'required',
                'way'   => 'required|in:google,facebook',
            ],
        ];
    }

    /**
     * @return int
     */
    public static function _isLogin()
    {
        $status = fMember::_CMember('has_login');

        return (1 == $status) ? 1 : 0;
    }

    public static function _chkLogin()
    {
        $isLogined = 0;
        $token     = '';
        if (isset($_SERVER['HTTP_MOBILE_TOKEN'])) {
            $token = $_SERVER['HTTP_MOBILE_TOKEN'];
        }

        if (!self::_isLogin()) {
            if ('' != $token) {
                // 無 session, login by token
                $cu = fMember::one($token, 'token');
                if (fMember::ST_FREEZE != $cu['status'] && $cu['expired_ts'] > date('Y-m-d H:i:s')) {
                    $isLogined = 1;
                    fMember::_setCurrent($cu['account'], $cu['id'], $cu['avatar'], $cu['nickname'], $cu['realname'], $cu['intro']);
                    fMember::renewExpired($cu['id']);
                }
            }

            if (1 != $isLogined) {
                return rMember::_return(8201);
            }
        }
    }
}
