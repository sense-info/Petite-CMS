<?php
namespace PCMS;

require_once '../f3cms/modules/Press/feed.php';
require_once '../f3cms/modules/Press/reaction.php';

use F3CMS\rPress as Elder;
use F3CMS\fPress as fPress;

class rPress extends Elder
{
    /**
     * @param array $row
     *
     * @return mixed
     */
    public static function handleRow($row = [])
    {
        $row['tags']      = fPress::lotsTag($row['id']);
        $row['authors']   = fPress::lotsAuthor($row['id']);
        $row['relateds']  = fPress::lotsRelated($row['id']);
        $row['meta']      = fPress::lotsMeta($row['id']);
        $row['terms']     = fPress::lotsTerm($row['id']);

        // read history file
        // $fc = new FCHelper('press');
        $row['history']        = []; // $fc->getLog('press_' . $row['id']);
        $row['status_publish'] = $row['status'];

        return $row;
    }
}
