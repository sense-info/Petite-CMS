<?php

namespace F3CMS;

class rStream extends Reaction
{
    public function do_list($f3, $args)
    {
        kStaff::_chkLogin(); // chkAuth(fStream::PV);

        $req = parent::_getReq();

        $req['page'] = (isset($req['page'])) ? ($req['page'] - 1) : 1;

        $req['limit'] = (isset($req['limit'])) ? min($req['limit'], 200) : 10;

        $rtn = fStream::limitRows($req['query'], $req['page'], $req['limit']);

        foreach ($rtn['subset'] as &$row) {
        }

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
        kStaff::_chkLogin(); // chkAuth($feed::PV_U);

        $req = parent::_getReq();

        $req['id']     = 0;
        $req['status'] = fStream::ST_ON;

        if (empty($req['parent_id']) || empty($req['target'])) {
            return self::_return(8004);
        }

        $id = fStream::save($req);

        return self::_return(1, ['id' => $id]);
    }
}
