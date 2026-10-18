<?php

namespace F3CMS;

/**
 * kit lib
 */
class kExcel extends Kit
{
    public static function dumpCsv($columns, $rows, $path = '/upload/doc/')
    {
        $root = f3()->get('ROOT') . f3()->get('BASE');

        if (!FSHelper::mkdir($root . $path) || !is_writable($root . $path)) {
            return [
                'code' => 0,
                'msg'  => 'failed to mkdir(' . $root . $path . ').',
            ];
        }

        $filename = substr(md5(uniqid(microtime(), 1)), 0, 15) . '.csv';
        $fullpath = $root . $path . $filename;
        $fp       = fopen($fullpath, 'w');

        if (false === $fp) {
            return [
                'code' => 0,
                'msg'  => 'failed to open file(' . $fullpath . ').',
            ];
        }

        fputcsv($fp, $columns);
        foreach ($rows as $row) {
            fputcsv($fp, $row);
        }
        fclose($fp);

        return [
            'code'     => 1,
            'msg'      => 'ok',
            'filename' => $path . $filename,
            'count'    => count($rows),
        ];
    }

    public static function loadCsv($filename)
    {
        $root = f3()->get('ROOT') . f3()->get('BASE');
        $csv  = file($root . $filename, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);

        if (false === $csv) {
            return [];
        }

        $rows = array_map('str_getcsv', $csv);
        if (!empty($rows[0][0])) {
            $rows[0][0] = preg_replace('/^\xEF\xBB\xBF/', '', $rows[0][0]);
        }

        return $rows;
    }

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
    public static function dumpFile($filename, $rows, $path)
    {
        // TODO: record current staff data

        f3()->set('rows', $rows);
        $tp      = \Template::instance();
        $content = $tp->render('xls/' . $filename . '.html');

        FSHelper::dumpFile(f3()->get('abspath') . $path, $content);
    }
}
