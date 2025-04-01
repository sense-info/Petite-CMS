<?php

namespace F3CMS;

/**
 * for render page
 */
class oMember extends Outfit
{
    /**
     * @param $args
     */
    public static function login($args)
    {
        if (kMember::_isLogin()) {
            f3()->reroute(f3()->get('uri') . '/member');
        }

        parent::render('member/login.twig', '會員登入', '/member/login');
    }

    /**
     * @param $args
     */
    public static function forgot($args)
    {
        if (kMember::_isLogin()) {
            f3()->reroute(f3()->get('uri') . '/member');
        }

        parent::render('member/forgot.twig', '忘記密碼', '/member/forgot');
    }

    /**
     * @param $args
     */
    public static function modify($args)
    {
        if (!kMember::_isLogin()) {
            f3()->reroute(f3()->get('uri') . '/');
        }

        $row = [
            'issue' => '#000',
        ];

        _dzv('cu', $row);

        parent::render('member/modify.twig', '我的帳號', '/member/modify');
    }

    /**
     * @param $args
     */
    public static function orders($args)
    {
        parent::render('member/orders.twig', '訂單紀錄', '/member/orders');
    }

    /**
     * @param $args
     */
    public static function verify($args)
    {
        if (empty($args['code'])) {
            f3()->error(404);
        }

        $cu = fMember::one($args['code'], 'm.verify_code');

        if (empty($cu)) {
            f3()->error(404);
        }

        fMember::changeStatus($cu['id'], fMember::ST_VERIFIED);

        fMember::_setCurrent($cu['account'], $cu['id'], $cu['avatar'], $cu['nickname'], $cu['realname'], $cu['intro']);

        f3()->reroute(f3()->get('uri'));

        // parent::render('/member/modify.twig', '我的帳號', '/member/modify');
    }

    /**
     * @param $args
     */
    public static function redirect($args)
    {
        $req = parent::_getReq();

        if (!empty($req['canonical'])) {
            Referer::set($req['canonical']);
        } else {
            Referer::set();
        }

        f3()->reroute(f3()->get('uri') . '/auth/' . $args['provider']);
    }

    /**
     * @param $data
     */
    public static function _oauth($data)
    {
        // fMember::_clearCurrent();

        if (kMember::_isLogin()) {
            $cu = kMember::reconnectSns($data);
        } else {
            $cu = kMember::loginFromSns($data);
        }

        if (empty($cu)) {
            exit('該社群帳號已有人使用，請洽詢客服');
        }

        $ref = Referer::get();
        Referer::del();
        if (false !== strpos($ref, 'canonical')) {
            parse_str($ref, $return_url);
            $return_url = $return_url['canonical'];
            $return_url = preg_replace('/([^:])(\/{2,})/', '$1/', $return_url);
        } else {
            $return_url = $ref;
        }

        f3()->reroute($return_url);
    }
}
