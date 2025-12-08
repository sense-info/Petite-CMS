<?php

namespace F3CMS;

class rPost extends Reaction
{
    public function do_load()
    {
        $req = parent::_getReq();

        if (empty($req['slug'])) {
            return parent::_return(8002);
        }

        $rtn = [];

        $fc  = new FCHelper('post');
        $key = 'post_' . parent::_lang() . '_' . $req['slug'] .'_'. f3()->get('siteName');
        $rtn = $fc->get($key, f3()->get('cache.post')); // 1 mins

        if (empty($rtn)) {
            if (is_numeric($req['slug'])) {
                $row = fPost::one($req['slug'], 'id', ['status' => fPost::ST_ON], 0);
            } else {
                $row = fPost::one($req['slug'], 'slug', ['status' => fPost::ST_ON], 0);
            }

            if (null == $row) {
                return parent::_return(8002);
            }

            $rtn = [
                'title'   => $row['title'],
                'content' => $row['content'],
            ];

            $fc->save($key, json_encode($rtn));
        } else {
            $rtn = json_decode(preg_replace('/<!--(?!\s*(?:\[if [^\]]+]|<!|>))(?:(?!-->).)*-->/s', '', $rtn), true);
        }

        return self::_return(1, $rtn);
    }
}
