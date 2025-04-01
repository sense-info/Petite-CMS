<?php

namespace F3CMS;

/**
 * React any request
 */
class rGenus extends Reaction
{
    /**
     * @param array $row
     *
     * @return mixed
     */
    public static function handleRow($row = [])
    {
        $row['tags'] = fGenus::lotsTag($row['id']);

        return $row;
    }

    /**
     * @param $f3
     * @param $args
     */
    public function do_get_opts($f3, $args)
    {
        // chkAuth(fGenus::PV_R);

        $req       = self::_getReq();
        $condition = [
            'm.status' => fGenus::ST_ON,
        ];

        if (!empty($req['group'])) {
            $condition['m.group'] = $req['group'];
        }

        if (!empty($req['query'])) {
            $condition['l.title[~]'] =  $req['query'];
        }

        $opts = fGenus::limitRows($condition, 0, 20);
        $rtn  = [];

        foreach ($opts['subset'] as &$row) {
            $rtn[] = ['id' => $row['id'], 'title' => $row['title'] . ' / ' . $row['slug']];
        }

        return self::_return(1, $rtn);
    }
}
