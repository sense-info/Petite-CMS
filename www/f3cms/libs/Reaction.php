<?php

namespace F3CMS;

class Reaction extends Module
{
    const RTN_DONE       = 'Done';
    const RTN_MISSCOLS   = 'MissCols';
    const RTN_WRONGDATA  = 'WrongData';
    const RTN_UNVERIFIED = 'UnVerified';

    /**
     * save whole form for backend
     *
     * @param object $f3   - $f3
     * @param array  $args - uri params
     */
    public function do_rerouter($f3, $args)
    {
        try {
            $args = parent::_escape($args, false);

            // Create an instance of the module class.
            $class = '\PCMS\r' . ucfirst($args['module']);

            // Check if the action has a corresponding method.
            $method = sprintf('do_%s', $args['method']);
            if (!method_exists($class, $method)) {
                $class = str_replace('PCMS', 'F3CMS', $class);

                if (!method_exists($class, $method)) {
                    return self::_return(1004, ['class' => $class, 'method' => $method]);
                }
            }

            // Create a reflection instance of the module, and obtaining the action method.
            $reflectionClass = new \ReflectionClass($class);

            $reflectionInstance = $reflectionClass->newInstance();
            $reflectionMethod   = $reflectionClass->getMethod($method);

            // Invoke module action.
            $reflectionMethod->invokeArgs(
                $reflectionInstance,
                [$f3, $args]
            );
        } catch (Exception $e) {
            return self::_return($e->getCode());
        }
    }

    /**
     * @param $f3
     * @param $args
     */
    public function do_list($f3, $args)
    {
        $req  = parent::_getReq();
        $feed = parent::_shift(get_called_class(), 'feed');

        chkAuth($feed::PV_R);

        $req['page']  = (isset($req['page'])) ? ($req['page'] - 1) : 0;
        $req['limit'] = (!empty($req['limit'])) ? max(min($req['limit'] * 1, 24), 12) : $feed::PAGELIMIT;

        if (!isset($req['query'])) {
            $req['query'] = '';
        }

        $rtn = $feed::limitRows($req['query'], $req['page']);

        return self::_return(1, $rtn);
    }

    /**
     * save whole form for backend
     *
     * @param object $f3   - $f3
     * @param array  $args - uri params
     */
    public function do_save($f3, $args)
    {
        $req  = parent::_getReq();
        $feed = parent::_shift(get_called_class(), 'feed');
        $kit  = parent::_shift(get_called_class(), 'kit');

        chkAuth($feed::PV_U);

        if (!isset($req['id'])) {
            return self::_return(8004);
        }

        if (parent::_exists($kit)) {
            $chkRule = $kit::rule('save');
            if (!empty($chkRule)) {
                // return self::_return(1, $chkRule);
                Validation::return($req, $chkRule);
            }
        }

        $id = $feed::save($req);

        $feed::handleSave($req);

        return self::_return(1, ['id' => $id]);
    }

    /**
     * save photo
     *
     * @param object $f3   - $f3
     * @param array  $args - uri params
     */
    public function do_upload($f3, $args)
    {
        kStaff::_chkLogin();

        $name = str_replace(['F3CMS\\', '\\'], ['', ''], get_called_class());

        [$type, $className] = preg_split('/(?<=[rfo])(?=[A-Z])/', $name);

        $thumb_str = strtolower($className) . '_thn';

        $default = f3()->exists($thumb_str) ? f3()->get($thumb_str) : f3()->get('default_thn');

        [$filename, $width, $height] = Upload::savePhoto(
            f3()->get('FILES'), [$default, f3()->get('all_thn')]
        );

        return self::_return(1, ['filename' => $filename]);
    }

    /**
     * save photo
     *
     * @param object $f3   - $f3
     * @param array  $args - uri params
     */
    public function do_upload_file($f3, $args)
    {
        kStaff::_chkLogin();

        $filename = Upload::saveFile(f3()->get('FILES'));

        return self::_return(1, ['filename' => $filename]);
    }

    /**
     * save one column
     *
     * @param object $f3   - $f3
     * @param array  $args - uri params
     */
    public function do_save_col($f3, $args)
    {
        $req  = parent::_getReq();
        $feed = parent::_shift(get_called_class(), 'feed');

        chkAuth($feed::PV_U);

        if (!isset($req['id'])) {
            return self::_return(8004);
        }

        $id = $feed::save_col($req);

        return self::_return(1, ['id' => $id]);
    }

    /**
     * delete one row
     *
     * @param object $f3   - $f3
     * @param array  $args - uri params
     */
    public function do_del($f3, $args)
    {
        $that = get_called_class();
        $feed = parent::_shift($that, 'feed');

        chkAuth($feed::PV_D);

        $req = parent::_getReq();

        if (!isset($req['id'])) {
            return self::_return(8004);
        }

        $feed::delRow($req['id']);

        return self::_return(1);
    }

    /**
     * get one row
     *
     * @param object $f3   - $f3
     * @param array  $args - uri params
     */
    public function do_get($f3, $args)
    {
        $that = get_called_class();
        $feed = parent::_shift($that, 'feed');

        chkAuth($feed::PV_R);

        $req = parent::_getReq();

        if (!isset($req['id'])) {
            return self::_return(8004);
        }

        if (0 == $req['id']) {
            // set default array
            $cu = ['id' => 0];
        } else {
            $cu = $feed::one($req['id']);
        }

        if (empty($cu)) {
            return self::_return(8106);
        } else {
            // handleCurrentRow
            $cu = $that::handleRow($cu);

            return self::_return(1, $cu);
        }
    }

    /**
     * @param $f3
     * @param $args
     */
    public function do_get_opts($f3, $args)
    {
        $that = get_called_class();
        $feed = parent::_shift($that, 'feed');

        chkAuth($feed::PV_R);

        $req = self::_getReq();

        if (!isset($req['query'])) {
            $req['query'] = '';
        }

        $rows = $feed::getOpts($req['query']);

        return self::_return(1, $rows);
    }

    /**
     * @param array $params
     *
     * @return mixed
     */
    public static function beforeSave($params = [])
    {
        return $params;
    }

    /**
     * @param array $row
     *
     * @return mixed
     */
    public static function handleRow($row = [])
    {
        return $row;
    }

    public static function _parseBackendQuery($query)
    {
        $feed = parent::_shift(get_called_class(), 'feed');

        $query = str_replace(['=', '&'], [':', ','], $query);
        $query = str_replace(',amp;', ',', $query);

        return (!empty($query)) ? $feed::genFilter($query) : [];
    }

    public static function formatMsgs()
    {
        return [
            'MissCols'   => [
                'code' => '8002',
                'msg'  => '欄位未填寫，請重新確認!',
            ],
            'WrongData'  => [
                'code' => '8204',
                'msg'  => '欄位資料有誤，請重新確認!',
            ],
            'UnVerified' => [
                'code' => '8205',
                'msg'  => 'TOKEN 不符，請重新取得!',
            ],
        ];
    }

    /**
     * new return mode
     *
     * @param mixed $code - whether sucess or error code
     * @param array $data - the data need to return
     *
     * @return array
     */
    public static function _return($code = 1, $data = [])
    {
        $return = ['code' => (int) $code];

        if (!empty($data)) {
            $return['data'] = $data;
        }

        f3()->set('SESSION.csrf', getCSRF());

        $return['csrf'] = f3()->get('SESSION.csrf');

        // detect jsonp or json
        if (f3()->get('GET.callback')
            && (0 === strpos(f3()->get('GET.callback'), '__jp') || 0 === strpos(f3()->get('GET.callback'), 'ng_jsonp_callback_'))) {
            header('Content-Type: application/javascript; charset=utf-8');
            exit(f3()->get('GET.callback') . ' (' . json_encode($return) . ');');
        } else {
            header('Content-Type: application/json; charset=utf-8');
            exit(json_encode($return));
        }
    }

    /**
     * _hashKey
     *
     * @param string $action - action name
     * @param array  $args   - hash source
     * @param string $secret - secret
     *
     * @return string
     */
    public static function _hashKey($action, $args, $secret)
    {
        $that      = get_called_class();
        $feed      = parent::_shift($that, 'feed');
        $hash_data = '';
        $keyAry    = $feed::hashGrid($action);

        // Create the string to be hashed.
        foreach ($keyAry as $k) {
            $hash_data .= ($args[$k] ?? '') . '-';
        }

        // Create hash key.
        return hash_hmac('sha256', $hash_data . round(time() / 300), $secret);
    }
}
