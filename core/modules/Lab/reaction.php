<?php

namespace F3CMS;

// use GuzzleHttp\Client;
// use GuzzleHttp\Exception\ClientException;

class rLab extends Reaction
{
    /**
     * @param $f3
     * @param $args
     */
    public function do_info($f3, $args)
    {
        echo '<meta charset="utf-8"><h2>Lab</h2> <pre>';

        if (!kStaff::_isLogin()) {
            exit;
        }

        echo 'Info-' . f3()->get('site_title') . '-' . gethostname() . ' as ' . $f3->get('APP_ENV') . PHP_EOL;
        echo date('Y/m/d H:i:s') . ' - 本機' . (($f3->get('crontabhost') != gethostname()) ? '不能' : '可') . '執行排程' . PHP_EOL;
        echo 'from: ' . f3()->IP . PHP_EOL . PHP_EOL . PHP_EOL;

        // /api/lab/info?isAllowedIP=1
        if (!empty($_GET['isAllowedIP'])) {
            self::test('isAllowedIP');
        }

        // /api/lab/info?batchDraft=1
        // 手動執行，狀態為"新建"之記錄
        if (!empty($_GET['batchDraft'])) {
            self::test('batchDraft');
        }

        // /api/lab/info?batchAnswer=1
        // 手動執行，狀態為"等待中"之記錄
        if (!empty($_GET['batchAnswer'])) {
            self::test('batchAnswer');
        }

        // /api/lab/info?batchImport=1
        // 手動執行，將結果匯入目標
        if (!empty($_GET['batchImport'])) {
            self::test('batchImport');
        }

        // /api/lab/info?draftGlossaryTermCount=1
        if (!empty($_GET['draftGlossaryTermCount'])) {
            self::test('draftGlossaryTermCount');
        }

        // /api/lab/info?dictionaryImport=1&path=/upload/doc/example.csv
        if (!empty($_GET['dictionaryImport'])) {
            self::test('dictionaryImport');
        }

        // /api/lab/info?dictionaryPressBind=1
        if (!empty($_GET['dictionaryPressBind'])) {
            self::test('dictionaryPressBind');
        }

        // /api/lab/info?tagPressBind=1
        if (!empty($_GET['tagPressBind'])) {
            self::test('tagPressBind');
        }

        if (!empty($_GET['repeat'])) {
            echo '<script type="text/javascript"> setTimeout(function () { location.reload(true); }, 3000); </script>';
        }
    }

    /**
     * @param $type
     */
    public static function test($type)
    {
        switch ($type) {
            case 'isAllowedIP':
                $whitelist = fOption::get('ip_whitelist');

                if (!empty($whitelist)) {
                    $whitelist = explode(PHP_EOL, $whitelist);
                } else {
                    $whitelist = ['*'];
                }

                if (!isAllowedIP(f3()->IP, $whitelist)) {
                    echo PHP_EOL . 'RTN_WRONGIP';
                } else {
                    echo PHP_EOL . 'RTN_SAFEIP';
                }
                break;
            case 'renameImg':
                set_time_limit(0);

                $filteredFiles = fMedia::lots([
                    'status'      => fMedia::ST_ON,
                    'pic[REGEXP]' => '[^ -~]',
                    'ORDER'       => ['id' => 'ASC'],
                    'LIMIT'       => 250,
                ]);

                if (empty($filteredFiles)) {
                    echo 'No matched media.' . PHP_EOL;
                    break;
                }

                $stats = [
                    'renamed' => 0,
                    'skipped' => 0,
                    'failed'  => 0,
                ];

                foreach ($filteredFiles as $file) {
                    $result = self::renameMediaPic($file);

                    if ('renamed' == $result['status']) {
                        $saved = fMedia::save([
                            'id'  => $file['id'],
                            'pic' => $result['to'],
                        ]);

                        if (empty($saved)) {
                            $result = self::renameResult('failed', $result['from'], $result['to'], 'database update failed');
                        }
                    }

                    $stats[$result['status']]++;

                    echo sprintf(
                        '[%s] #%d %s => %s',
                        strtoupper($result['status']),
                        $file['id'],
                        $result['from'],
                        $result['to']
                    );

                    if (!empty($result['message'])) {
                        echo ' (' . $result['message'] . ')';
                    }

                    echo PHP_EOL;
                }

                echo sprintf(
                    'Summary: renamed=%d skipped=%d failed=%d',
                    $stats['renamed'],
                    $stats['skipped'],
                    $stats['failed']
                ) . PHP_EOL;

                break;
            case 'batchDraft':
                // 增加 PHP 腳本的最大執行時間
                set_time_limit(0);
                fDraft::cronjob(1);
                break;
            case 'batchAnswer':
                // 增加 PHP 腳本的最大執行時間
                set_time_limit(0);
                fDraft::cronAnswer(1);
                break;
            case 'batchImport':
                // 增加 PHP 腳本的最大執行時間
                set_time_limit(0);
                fDraft::cronImport(1);
                break;
            case 'draftGlossaryTermCount':
                set_time_limit(0);
                $rows   = fDraft::glossaryTermCountRows('seohelper');
                $result = kExcel::dumpCsv(['term', 'count'], $rows, '/upload/doc/');
                if (!empty($result['filename'])) {
                    echo 'filename: ' . $result['filename'] . PHP_EOL;
                }
                break;
            case 'dictionaryImport':
                $path = $_GET['path'] ?? '';
                $root = f3()->get('ROOT') . f3()->get('BASE');
                $docRoot = realpath($root . '/upload/doc');
                $filename = realpath($root . $path);

                if (empty($docRoot) || empty($filename)
                    || 0 !== strpos($filename, $docRoot . DIRECTORY_SEPARATOR)
                    || 'csv' !== strtolower(pathinfo($filename, PATHINFO_EXTENSION))) {
                    echo 'invalid csv path' . PHP_EOL;
                    break;
                }

                $rows = kExcel::loadCsv($path);
                echo jsonEncode(fDictionary::importTranslations($rows)) . PHP_EOL;
                break;
            case 'dictionaryPressBind':
                set_time_limit(0);
                echo jsonEncode(fDictionary::autoBindTerms('press')) . PHP_EOL;
                break;
            case 'tagPressBind':
                set_time_limit(0);
                echo jsonEncode(fTag::autoBindTerms('press')) . PHP_EOL;
                break;
            case 'getHashCost':
                echo 'Appropriate Cost Found: ' . kLab::getHashCost() . PHP_EOL; // 50 milliseconds
                break;
            default:
                // code...
                break;
        }
    }

    private static function renameMediaPic($file)
    {
        $oldPic = $file['pic'];

        $pathInfo = pathinfo(parse_url($oldPic, PHP_URL_PATH));
        $basename = empty($pathInfo['filename']) ? '' : rawurldecode($pathInfo['filename']);

        if (!preg_match('/[^\x20-\x7E]/u', $basename)) {
            return self::renameResult('skipped', $oldPic, $oldPic, 'basename already ascii');
        }

        $newBase = substr(md5($file['id'] . '|' . $oldPic), 0, 15);
        if ($newBase === $basename) {
            return self::renameResult('skipped', $oldPic, $oldPic, 'basename unchanged');
        }

        $renamed = FSHelper::renameMediaPic($oldPic, $newBase);
        if (!$renamed['ok']) {
            return self::renameResult('failed', $oldPic, $oldPic, $renamed['message']);
        }

        return self::renameResult('renamed', $oldPic, $renamed['pic']);
    }

    private static function renameResult($status, $from, $to, $message = '')
    {
        return [
            'status'  => $status,
            'from'    => $from,
            'to'      => $to,
            'message' => $message,
        ];
    }
}
