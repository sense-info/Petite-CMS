<?php

namespace F3CMS;

class rPost extends Reaction
{
    public function do_single($f3, $args)
    {
        $req = parent::_getReq();

        $rtn = fPost::one($req['slug'], 'slug', ['status' => fPost::ST_ON], 0);

        if (empty($rtn)) {
            f3()->error(404);
        }

        return self::_return(1, $rtn);
    }
}
