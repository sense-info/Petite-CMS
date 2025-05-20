<?php

namespace F3CMS;

/**
 * kit lib
 */
class kExcel extends Kit
{
    /**
     * @param $filename
     * @param $rows
     */
    public static function render($filename, $rows)
    {
        // TODO: record current staff data

        if (!$rows) {
            header('Content-Type:text/html; charset=utf-8');
            echo '無結果';
        } else {
            f3()->set('rows', $rows);

            echo Outfit::_setXls($filename . '_' . date('YmdHis'))
                ->render('xls/' . $filename . '.html', 'application/vnd.ms-excel');
        }
    }

    /**
     * @param $filename
     * @param $rows
     */
    public static function renderCSV($filename, $rows)
    {
        // TODO: record current staff data

        if (!$rows) {
            header('Content-Type:text/html; charset=utf-8');
            echo '無結果';
        } else {
            f3()->set('rows', $rows);

            header('Content-Disposition:filename=' . $filename . '_' . date('YmdHis') . '.csv');

            echo Outfit::_origin()->render('csv/' . $filename . '.html', 'text/csv');
        }
    }
}
