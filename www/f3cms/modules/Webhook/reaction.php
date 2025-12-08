<?php

namespace F3CMS;

class rWebhook extends Reaction
{
    /**
     * @param $f3
     * @param $args
     */
    public function do_heartbeat($f3, $args)
    {
        $req = self::_getReq();

        if (empty($_SERVER['HTTP_AUTHORIZATION'])) {
            return self::_return(8004);
        }

        // if the Authorization is not equal to the secret key, then it is invalid
        $authorization = str_replace('Bearer ', '', $_SERVER['HTTP_AUTHORIZATION']);
        if ($authorization !== f3()->get('webhook.secret')) {
            return self::_return(8201, ['msg' => 'Bearer authorization Failed']);
        }

        return self::_return(1, ['service_mail' => fOption::get('service_mail')]);
    }

    /**
     * @param $f3
     * @param $args
     */
    public function do_getPress($f3, $args)
    {
        $req = self::_req();

        if (empty($_SERVER['HTTP_AUTHORIZATION'])) {
            return self::_rtn([
                'code' => 8201,
                'data' => ['msg' => 'Bearer authorization Failed']
            ]);
        }

        // if the Authorization is not equal to the secret key, then it is invalid
        $authorization = str_replace('Bearer ', '', $_SERVER['HTTP_AUTHORIZATION']);
        if ($authorization !== f3()->get('webhook.secret')) {
            return self::_rtn([
                'code' => 8201,
                'data' => ['msg' => 'Bearer authorization Failed']
            ]);
        }

        $msg = Validation::msg($req, kWebhook::rule('getPress'));

        if ('' == $msg) {
            $msg = 'Success!';
        }

        if (is_array($msg)) {
            $msg = implode(', ', $msg);
        }

        if ('Success!' != $msg) {
            f3()->status(404);
        }

        $cu = fPress::one($req['press_id']);

        if (empty($cu)) {
            return self::_rtn([
                'code'    => 8106
            ]);
        }

        $cu = rPress::handleRow($cu);

        $subset = fMedia::limitRows([
            'm.status'    => fMedia::ST_ON,
            'm.target'    => 'Press',
            'm.parent_id' => $cu['id'],
        ], 0, 30, ',m.insert_ts');

        $cu['pics'] = $subset['subset'];

        $uri = f3()->get('uri');

        if (!empty($cu['cover'])) {
            $cu['cover'] =  $uri . $cu['cover'];
        }

        if (!empty($cu['banner'])) {
            $cu['banner'] =  $uri . $cu['banner'];
        }

        foreach ($cu['lang'] as $lang => $row) {
            $cu['lang'][$lang]['content'] = str_replace('src="/upload/', 'src="'. $uri .'/upload/', $row['content']);
        }

        foreach ($cu['pics'] as $idx => $row) {
            $cu['pics'][$idx]['pic'] = $uri . $row['pic'];
            $cu['pics'][$idx]['lang'] = fMedia::lotsLang($row['id']);

            unset($cu['pics'][$idx]['id']);
            unset($cu['pics'][$idx]['title']);
        }

        $cu['link'] = $uri . '/p/' . $cu['id'];
        $cu['tags'] = '';
        $cu['authors'] = '';
        $cu['relateds'] = '';
        $cu['terms'] = '';

        unset($cu['history']);
        unset($cu['id']);
        unset($cu['status_publish']);

        self::_rtn([
            'code'    => 1,
            'data' => $cu,
        ]);
    }

    /**
     * handle angular post data
     *
     * @return array - post data
     */
    public static function _req()
    {
        $rtn = [];

        $str = f3()->get('BODY');
        if (empty($str)) {
            $str = file_get_contents('php://input');
        }

        $rtn = json_decode($str, true);
        if (!(JSON_ERROR_NONE == json_last_error())) {
            parse_str($str, $rtn);
        }

        if (empty($rtn)) {
            $rtn = f3()->get('REQUEST');
        }

        return $rtn;
    }

    /**
     * new return mode
     *
     * @param mixed $code - whether sucess or error code
     * @param array $data - the data need to return
     *
     * @return array
     */
    private static function _rtn($return = ['message' => 'Success!'])
    {
        header('Content-Type: application/json; charset=utf-8');
        exit(json_encode($return));
    }
}
