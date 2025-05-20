<?php

namespace F3CMS;

/**
 * data feed
 */
class fDraft extends Feed
{
    public const MTB       = 'draft';
    public const MULTILANG = 0;

    public const ST_NEW     = 'New';
    public const ST_WAITING = 'Waiting';
    public const ST_DONE    = 'Done';
    public const ST_INVALID = 'Invalid';
    public const ST_USED    = 'Used';

    public const BE_COLS = 'm.id,m.press_id,m.owner_id,m.status,m.lang,m.method,m.intent,m.insert_ts,m.last_ts,m.last_user,m.insert_user';

    /**
     * @param $req
     *
     * @return mixed
     */
    public static function add($req)
    {
        mh()->insert(self::fmTbl(), array_merge($req, [
            'status'     => self::ST_NEW,
            'insert_ts'  => date('Y-m-d H:i:s'),
            'insert_user'=> fStaff::_current('id'),
        ]));

        return self::chkErr(mh()->id());
    }

    public static function reportError($pid, $error)
    {
        $data = mh()->update(self::fmTbl(), [
            'status' => self::ST_INVALID,
            'content' => $error,
        ], [
            'id' => $pid,
        ]);

        return parent::chkErr($data->rowCount());
    }

    public static function acceptLang()
    {
        return [
            'tw' => '中文',
            'en' => '英語',
            'jp' => '日本語',
            'ko' => '韓語',
            // 'fr' => '法語',
        ];
    }

    public static function cronjob($limit = 5)
    {
        mh(true)->info();

        $data = fDraft::limitRows([
            'm.status' => fDraft::ST_NEW,
            'ORDER' => ['m.id' => 'ASC'],
        ], 0, $limit, ',m.guideline');

        if ($data['count'] > 0) {
            self::saveCol([
                'col' => 'status',
                'val' => self::ST_WAITING,
                'pid' => \__::pluck($data['subset'], 'id'),
            ]);
        }

        \__::map($data['subset'], function ($row) {
            $method   = 'batch' . ucfirst($row['method']);
            $class  = '\F3CMS\fDraft';

            if (method_exists($class, $method)) {
                $result = call_user_func($class . '::' . $method, $row);
            } else {
                $result = '';
            }

            echo $result;

            // TODO: next step in flow

            usleep(300000); // 0.3s
        });
    }

    public static function batchWriting($row)
    {
        $rtn = PHP_EOL . $row['id'] . ') Writing : ';

        $reply = kDraft::writing($row['intent'], $row['guideline']);
        usleep(30000); // 0.03s

        return self::_formatAiRtn($row['id'], $reply, $rtn);
    }

    public static function batchGuideline($row)
    {
        $rtn = PHP_EOL . $row['id'] . ') Guideline : ';

        $reply = kDraft::guideline($row['intent']);
        usleep(30000); // 0.03s

        return self::_formatAiRtn($row['id'], $reply, $rtn);
    }

    public static function batchLayout($row)
    {
        $rtn = PHP_EOL . $row['id'] . ') Guideline : ';

        $reply = kDraft::layout($row['intent']);
        usleep(30000); // 0.03s

        return self::_formatAiRtn($row['id'], $reply, $rtn);
    }

    public static function batchExpert($row)
    {
        $rtn = PHP_EOL . $row['id'] . ') Expert Discussion : ';

        $reply = kDraft::expertDiscussion($row['intent']);
        usleep(30000); // 0.03s

        return self::_formatAiRtn($row['id'], $reply, $rtn);
    }

    public static function batchSeohelper($row)
    {
        $rtn = PHP_EOL . $row['id'] . ') Seohelper : ';

        $reply = kDraft::seohelper($row['guideline']);
        usleep(30000); // 0.03s

        return  self::_formatAiRtn($row['id'], $reply, $rtn);
    }

    public static function batchTranslate($row)
    {
        $rtn = PHP_EOL . $row['id'] . ') Translate : ';

        $reply = kDraft::translate($row['lang'], $row['guideline']);
        usleep(30000); // 0.03s

        if (stripos($reply, '再問我一次') === 0) {
            self::reportError($row['id'], 'wrong ai result');
            $rtn .= 'ai 說再問我一次';

            return $rtn;
        }

        if (preg_match('/```json/', $reply)) {
            $reply = str_replace(['```json', '```'], '', $reply);
        }

        self::saveCol([
            'col' => 'content',
            'val' => $reply,
            'pid' => $row['id'],
        ]);

        $json = jsonDecode($reply);
        if (!is_array($json) || empty($json['article_title']) || empty($json['article_info']) || empty($json['article_content'])) {

            $rtn .= '未完成';

            self::saveCol([
                'col' => 'status',
                'val' => self::ST_INVALID,
                'pid' => $row['id'],
            ]); // don't use self::reportError, keep json in content
        } else {
            self::saveCol([
                'col' => 'status',
                'val' => self::ST_DONE,
                'pid' => $row['id'],
            ]);
            $rtn .= 'Done';
        }

        return $rtn;
    }

    private static function _formatAiRtn($pid, $reply, $rtn = '')
    {
        if (stripos($reply, '再問我一次') === 0) {
            self::reportError($pid, 'wrong ai result');
            $rtn .= 'ai 說再問我一次';

            return $rtn;
        }

        if (preg_match('/```json/', $reply)) {
            $reply = str_replace(['```json', '```'], '', $reply);
        }

        $data = mh()->update(self::fmTbl(), [
            'status' => self::ST_DONE,
            'content' => $reply,
        ], [
            'id' => $pid,
        ]);

        $rtn .= 'Done';

        return $rtn; // TODO: return json
    }

}
