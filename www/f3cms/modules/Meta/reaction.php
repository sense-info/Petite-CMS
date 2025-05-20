<?php

namespace F3CMS;

/**
 * React any request
 */
class rMeta extends Reaction
{
    /**
     * @param array $row
     *
     * @return mixed
     */
    public static function handleRow($row = [])
    {
        $row['tags'] = fMeta::lotsGenus($row['id']);

        return $row;
    }

    /**
     * @param $f3
     * @param $args
     */
    public function do_list($f3, $args)
    {
        $req = parent::_getReq();

        chkAuth(fMeta::PV_R);

        if (fStaff::_current('lang')) {
            f3()->set('acceptLang', \__::pluck(fStaff::_current('lang'), 'key'));
        }

        $req['page']  = ($req['page']) ? ($req['page'] - 1) : 1;
        $req['query'] = (isset($req['query'])) ? $req['query'] : [];

        $rtn = fMeta::limitRows($req['query'], $req['page'], 12);

        foreach ($rtn['subset'] as $k => $row) {
            $rtn['subset'][$k]['tags'] = fMeta::lotsGenus($row['id']);
        }

        return parent::_return(1, $rtn);
    }

    /**
     * @param $f3
     * @param $args
     */
    public function do_all($f3, $args)
    {
        $req          = parent::_getReq();
        $req['query'] = (isset($req['query'])) ? $req['query'] : [];

        $rtn = fMeta::limitRows($req['query'], 0, 100);

        foreach ($rtn['subset'] as $k => $row) {
            $rtn['subset'][$k]['tags'] = '[' . implode('],[', \__::pluck(fMeta::lotsGenus($row['id']), 'id')) . ']';
        }

        return parent::_return(1, $rtn['subset']);
    }
}
