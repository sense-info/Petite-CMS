<?php

namespace F3CMS;

/**
 * for render page
 */
class oRole extends Outfit
{
    // public function do_set($f3, $args)
    // {
    //     $list = fRole::getAuth();
    //     f3()->set('auth_list', $list);

    //     if ($_POST['auth']) {
    //         $priv = fRole::parseAuth($_POST['auth']);

    //         foreach ($list as $k => $v) {
    //             $chk_priv[] = [
    //                 'name' => $k,
    //                 'has' => fRole::hasAuth($priv, $k),
    //             ];
    //         }

    //         f3()->set('auth_priv', $priv);
    //         f3()->set('auth_chk', $chk_priv);

    //         // print_r(fRole::reverseAuth($priv));
    //         // print_r(fRole::parseAuthVal(fRole::reverseAuth($priv)));
    //         // print_r(fRole::parseAuthIdx(fRole::reverseAuth($priv)));
    //     }

    //     parent::wrapper('role/setting.html', '角色權限 TEST', '/');
    // }
}
