<?php

namespace F3CMS;

class rTrack extends Reaction
{
    /**
     * @param $f3
     * @param $args
     */
    public function do_pass($f3, $args)
    {
        $req = parent::_getReq();
        $mid = fMember::_CMember();
        $vid = intval($req['vid']); // video id

        if ($vid > 0) {
            // bad performance
            // if ($mid > 0 && !f3()->exists('SESSION.fp')) {
            //     fFootprint::setSession($vid, $mid);
            // }

            fTrack::insert([
                'uid'   => date('ymdHis') . '-' . $mid . '-' . $vid,
                'vid'   => $vid,
                'mid'   => $mid,
                'spent' => 10,
                'pos'   => intval($req['pos']),
                'ts'    => date('Y-m-d H:i:s'),
            ]);
        }

        echo '1';
    }

    /**
     * @param $f3
     * @param $args
     */
    public function do_hourly($f3, $args)
    {
        rStaff::_chkLogin();

        $req = parent::_getReq();

        $req['page']  = (!empty($req['page'])) ? ($req['page'] - 1) : 0;
        $req['limit'] = (!empty($req['limit'])) ? max(min($req['limit'] * 1, 150), 12) : 150;

        $rtn = fTrack::hourlyStatRows($req['query'], $req['page']);

        return self::_return(1, $rtn);
    }

    /**
     * @param $f3
     * @param $args
     */
    public function do_daily($f3, $args)
    {
        rStaff::_chkLogin();

        $req = parent::_getReq();

        $req['page']  = (!empty($req['page'])) ? ($req['page'] - 1) : 0;
        $req['limit'] = (!empty($req['limit'])) ? max(min($req['limit'] * 1, 150), 12) : 150;

        $rtn = fTrack::dailyStatRows($req['query'], $req['page']);

        return self::_return(1, $rtn);
    }

    /**
     * @param $f3
     * @param $args
     */
    public function do_stat($f3, $args)
    {
        $req = parent::_getReq();

        if (empty($req['pid'])) {
            return parent::_return(8002, ['msg' => 'PID 未填寫!!']);
        }

        if (!kMember::chkPID($req['pid'])) {
            parent::_return(8002, ['msg' => 'PID 未正確填寫!!']);
        }

        $fc = new FCHelper('track');
        $fn = 'track_' . parent::_lang() . '_' . str_replace(['-', ','], ['_', '_'], $req['pid']) . '_' . $req['mode'];

        $req['mode'] = (empty($req['mode'])) ? 'weekly' : $req['mode'];

        $rtn = $fc->get($fn, f3()->get('cache.track')); // 30 mins

        if (empty($rtn) || 'minutely' == $req['mode']) {
            $rtn = fTrack::stat($req['pid'], $req['mode']);

            if ('minutely' != $req['mode']) {
                $fc->save($fn, json_encode($rtn));
            }
        } else {
            $rtn = json_decode(preg_replace('/<!--(?!\s*(?:\[if [^\]]+]|<!|>))(?:(?!-->).)*-->/s', '', $rtn), true);
        }

        return parent::_return(1, $rtn);
    }
}
