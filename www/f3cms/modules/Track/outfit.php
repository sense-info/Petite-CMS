<?php

namespace F3CMS;

/**
 * for render page
 */
class oTrack extends Outfit
{
    public static function xls($args)
    {
        if (!rStaff::_isLogin()) {
            f3()->reroute(f3()->get('uri') . '/backend/');
        }

        $req = parent::_getReq();

        $rtn = fTrack::dailyStatRows($req['query'], 0, 15000);

        if (!$rtn['subset']) {
            header('Content-Type:text/html; charset=utf-8');
            echo '無結果';
        } else {
            $rtn['subset'] = \__::map($rtn['subset'], function ($cu) {
                return $cu;
            });

            kExcel::render('track_daily', $rtn['subset']);
        }
    }

    public static function hourly($args)
    {
        if (!rStaff::_isLogin()) {
            f3()->reroute(f3()->get('uri') . '/backend/');
        }

        $req = parent::_getReq();

        $rtn = fTrack::hourlyStatRows($req['query'], 0, 15000);

        if (!$rtn['subset']) {
            header('Content-Type:text/html; charset=utf-8');
            echo '無結果';
        } else {
            $rtn['subset'] = \__::map($rtn['subset'], function ($cu) {
                return $cu;
            });

            kExcel::render('track_hourly', $rtn['subset']);
        }
    }
}
