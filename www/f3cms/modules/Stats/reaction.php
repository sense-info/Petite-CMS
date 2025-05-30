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
    public function do_ga($f3, $args)
    {
        // chkAuth(fStats::PV_R);

        $req = parent::_getReq();

        if (empty($req['query'])) {
            $req['query'] = ',insert_ts:28daysAgo';
        }

        $req['page'] = (isset($req['page'])) ? ($req['page'] - 1) : 0;

        $req['query'] = fStats::_handleQuery($req['query']);

        if (!empty($req['query']['insert_ts[<>]'])) {
            $start = $req['query']['insert_ts[<>]'][0];
            $end = $req['query']['insert_ts[<>]'][1];
        } else {
            $start = '28daysAgo'; // '7daysAgo';
            $end = 'today'; // 'today';
        }

        // TODO: cache this

        $ga = new GAHelper(
            f3()->get('gcp_property'),
            f3()->get('configpath') . '/' . f3()->get('gcp_json')
        );

        $data1 = $ga->byDate($start, $end);
        $data2 = $ga->byCountry($start, $end);

        return parent::_return(1, ['subset' =>
            ['date' => $data1, 'country' => $data2]
        ]);
    }
}
