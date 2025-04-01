<?php

namespace F3CMS;

/**
 * for render page
 */
class oAnnal extends Outfit
{
    public static function excel($args)
    {
        chkAuth(fAnnal::PV_R);

        $req = parent::_getReq();

        $rtn = fAnnal::limitRows($req['query'], 0, 50000);

        if (!$rtn['subset']) {
            header('Content-Type:text/html; charset=utf-8');
            echo '無結果';
        } else {
            $tp = \Template::instance();

            $uri = f3()->get('uri');

            foreach ($rtn['subset'] as &$row) {
            }

            f3()->set('rows', $rtn['subset']);

            Outfit::_setXls('annal_' . date('YmdHis'));
            // header('Content-Type:text/html; charset=utf-8');
            echo $tp->render('xls/annals.html', 'application/vnd.ms-excel');
        }
    }
}
