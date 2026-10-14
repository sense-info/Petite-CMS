<?php

namespace PCMS;

use F3CMS\kPress as Elder;
use F3CMS\fPress as fPress;

/**
 * kit lib
 */
class kPress extends Elder
{
    /**
     * @param $email
     * @param $verify_code
     */
    public static function fartherData($id)
    {
        $news = fPress::limitRows([
            'm.status' => [fPress::ST_PUBLISHED, fPress::ST_CHANGED],
            'm.id[!]' => $id,
        ], 0, 3);

        _dzv('news', $news['subset']);
    }
}
