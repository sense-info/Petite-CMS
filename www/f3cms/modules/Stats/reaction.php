<?php

namespace F3CMS;

/**
 * React any request
 */
class rStats extends Reaction
{
    /**
     * @param $f3
     * @param $args
     */
    public function do_market($f3, $args)
    {
        chkAuth(fStats::PV_R);

        $req = parent::_getReq();

        if (empty($req['query'])) {
            $req['query'] = ',insert_ts:today';
        }

        $req['page'] = (isset($req['page'])) ? ($req['page'] - 1) : 0;

        $req['query'] = fStats::_handleQuery($req['query']);

        if (!empty($req['query']['insert_ts[<>]'])) {
            $req['query']['insert_ts[<>]'][0] = $req['query']['insert_ts[<>]'][0] . ' 00:00:00';
            $req['query']['insert_ts[<>]'][1] = $req['query']['insert_ts[<>]'][1] . ' 23:59:59';
        }

        $rtn = [
            'subset' => [
                'join_member_cnt' => fMember::_total(fMember::fmTbl() . '(m)', [
                    'm.status[!]'     => fMember::ST_FREEZE,
                    'm.insert_ts[<>]' => $req['query']['insert_ts[<>]'],
                ], fMember::genJoin()),
                'public_video_cnt' => fVideo::_total(fVideo::fmTbl() . '(m)', [
                    'm.status'         => fVideo::ST_ON,
                    'm.phase'          => 'Published',
                    'm.publish_ts[<>]' => $req['query']['insert_ts[<>]'],
                ], fVideo::genJoin()),
            ],
        ];

        return parent::_return(1, $rtn);
    }
}
