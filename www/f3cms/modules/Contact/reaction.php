<?php

namespace F3CMS;

class rContact extends Reaction
{
    /**
     * @param $f3
     * @param $args
     */
    public function do_add_new($f3, $args)
    {
        $req = parent::_getReq();

        // if (!chkCSRF()) {
        //     return parent::_return(8002, ['msg' => '欄位未填寫，請重新確認! (miss_token)']);
        // }

        Validation::return($req, kContact::rule('add_new'));

        if (fContact::count() > 4) {
            return parent::_return(8106, ['msg' => '資料過多，請稍後再試!']);
        }

        $pid = fContact::insert($req);

        if ($pid) {
            f3()->set('pid', $pid);

            f3()->set('name', $req['name']);
            f3()->set('email', $req['email']);

            f3()->set('phone', !empty($req['phone']) ? $req['phone'] : '');
            f3()->set('type', !empty($req['type']) ? $req['type'] : '');
            f3()->set('company', !empty($req['company']) ? $req['company'] : '');

            f3()->set('message', nl2br($req['message']));

            $opts = fOption::load('', 'Preload');

            $api = new MPThelper(f3()->get('mp.merchant'), f3()->get('mp.secret'));

            $action       = 'sendmail';
            $request_data = [
                'subject' => f3()->get('site_title') . ' 網站詢問通知',
                'content' => Sender::renderBody('contact'),
                'recipient' => 'trevor@sense-info.co', // $opts['default']['contact_mail'],
            ];

            $api->call($action, $request_data);

            return parent::_return(1, ['msg' => '感謝您~~']);
        } else {
            return parent::_return(7101, ['msg' => '網站異常，請稍後再試!']);
        }
    }
}
