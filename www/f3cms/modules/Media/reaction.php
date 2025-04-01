<?php

namespace F3CMS;

class rMedia extends Reaction
{
    /**
     * @param $f3
     * @param $args
     */
    public function do_list($f3, $args)
    {
        $req = parent::_getReq();
        chkAuth(fMedia::PV_R);

        $req['page']  = (isset($req['page'])) ? ($req['page'] - 1) : 0;
        $req['query'] = (!isset($req['query'])) ? '' : $req['query'];

        $rtn = fMedia::limitRows($req['query'], $req['page'], 48);

        return self::_return(1, $rtn);
    }

    /**
     * @param $f3
     * @param $args
     */
    public function do_show($f3, $args)
    {
        $cu = fMedia::one($args['slug'], 'slug', ['status' => fMedia::ST_ON]);

        if (empty($cu)) {
            f3()->error(404);
        }

        f3()->reroute($cu['pic']);
    }

    /**
     * @param $f3
     * @param $args
     */
    public function do_renewParent($f3, $args)
    {
        kStaff::_chkLogin();

        $req = parent::_getReq();

        $rtn = mh()->update(fMedia::fmTbl(), [
            'parent_id' => $req['pid'],
        ], [
            'id'     => $req['img'],
            'target' => $req['target'],
        ]);

        return self::_return(1, ['cnt' => $rtn->rowCount()]);
    }

    /**
     * save photo
     *
     * @param object $f3   - $f3
     * @param array  $args - uri params
     *
     * @return array - std json
     */
    public function do_editor_upload($f3, $args)
    {
        kStaff::_chkLogin();

        [$filename, $width, $height, $title] = Upload::savePhoto(
            f3()->get('FILES'), [f3()->get('all_thn')]
        );

        $response       = new \stdClass();
        $response->link = f3()->get('uri') . $filename;
        echo stripslashes(json_encode($response));
    }

    /**
     * save photo
     *
     * @param object $f3   - $f3
     * @param array  $args - uri params
     */
    public function do_chip_upload($f3, $args)
    {
        kMember::_chkLogin();

        $default = f3()->get('default_thn');

        [$filename, $width, $height] = Upload::savePhoto(
            f3()->get('FILES'), [$default, f3()->get('all_thn')], 'file'
        );

        $pid = fMedia::insert([
            'title' => date('YmdHis'),
            'slug'  => fMedia::renderUniqueNo(16),
            'pic'   => $filename,
        ]);

        return self::_return(1, ['url' => $filename, 'id' => $pid]);
    }

    /**
     * save photo
     *
     * @param object $f3   - $f3
     * @param array  $args - uri params
     */
    public function do_exhib_upload($f3, $args)
    {
        kMember::_chkLogin();

        $default = f3()->get('default_thn');

        [$filename, $width, $height] = Upload::savePhoto(
            f3()->get('FILES'), [$default, f3()->get('all_thn')], 'file'
        );

        $pid = fMedia::insert([
            'title' => date('YmdHis'),
            'slug'  => fMedia::renderUniqueNo(16),
            'pic'   => $filename,
        ]);

        return self::_return(1, ['url' => $filename, 'id' => $pid]);
    }
}
