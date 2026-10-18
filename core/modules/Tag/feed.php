<?php

namespace F3CMS;

/**
 * data feed
 */
class fTag extends Feed
{
    const MTB    = 'tag';
    const ST_ON  = 'Enabled';
    const ST_OFF = 'Disabled';

    const PAGELIMIT = 1000;

    const BE_COLS = 'm.id,l.title,m.slug,m.cate_id,m.counter';

    /**
     * @param $req
     *
     * @return int
     */
    public static function handleSave($req)
    {
        if (0 != $req['id']) {
            // fPress::batchRenew('tag', $req['id']);
        }

        return 1;
    }

    /**
     * @param $pid
     * @param $reverse
     */
    public static function lotsRelated($pid)
    {
        $pk = 'tag_id';
        $fk = 'related_id';

        $filter = [
            'r.' . $pk => $pid,
            't.status' => self::ST_ON,
        ];

        return mh()->select(self::fmTbl('related') . '(r)', ['[>]' . self::fmTbl() . '(t)' => ['r.related_id' => 'id']], ['t.id', 't.slug', 't.title'], $filter);
    }

    /**
     * @param $query
     */
    public static function get_opts($query = '', $column = 'title')
    {
        $filter = ['LIMIT' => 100];

        if ('' != $query) {
            $filter['OR']['title[~]'] = $query;
            $filter['OR']['slug[~]']  = $query;
        }

        return mh()->select(self::fmTbl(), ['id', $column], $filter);
    }

    public static function fromDraft($pid, $lang, $data)
    {
        $old = mh()->get(self::fmTbl('lang'), ['id'], [
            'parent_id' => $pid,
            'lang'      => $lang,
        ]);

        if (empty($old)) {
            mh()->insert(self::fmTbl('lang'), [
                'parent_id' => $pid,
                'lang'      => $lang,
            ]);
        }

        $updates = [
        ];

        if (!empty($data['title'])) {
            $updates['title'] = $data['title'];
        }

        if (!empty($data['info'])) {
            $updates['info'] = $data['info'];
        }

        $data = mh()->update(self::fmTbl('lang'), $updates, [
            'parent_id' => $pid,
            'lang'      => $lang,
        ]);

        return parent::chkErr($data->rowCount());
    }

    /**
     * get detail by tag id
     *
     * @param int $pid - parent id
     *
     * @return array
     */
    public static function detail($pid, $type = 'all')
    {
        if ('all' == $type) {
            $cols = '*';
        } else {
            $cols = '`cover`, `banner`, `info`';
        }

        $rows = self::exec('SELECT ' . $cols . ' FROM `' . self::fmTbl('detail') . '` WHERE `parent_id`=:pid LIMIT 1 ', [':pid' => $pid]);

        if (1 != count($rows)) {
            return null;
        } else {
            return $rows[0];
        }
    }

    public static function setPressCnt($pid)
    {
        $cnt = self::exec('SELECT COUNT(r.`press_id`) AS `cnt` FROM `' . fPress::fmTbl('tag') . '` AS `r` ' .
            ' INNER JOIN `' . fPress::fmTbl() . '` AS `m` ON `r`.`press_id` = `m`.`id` AND `m`.`status` IN (\'' . fPress::ST_PUBLISHED . '\', \'' . fPress::ST_CHANGED . '\') ' .
            'WHERE `r`.`tag_id` = :pid LIMIT 1', [':pid' => $pid], true);
        $cnt = ($cnt) ? $cnt['cnt'] * 1 : 0;

        $rtn = mh()->update(self::fmTbl(), [
            'counter' => $cnt,
        ], [
            'id' => $pid,
        ]);

        return self::chkErr($rtn->rowCount());
    }    
    
    /**
     * Find words in the dictionary and insert new ones if they don't exist.
     *
     * @param array $words
     * @return array [word => id]
     * @throws \Exception If there is an error inserting a new word.
     */
    public static function findWord(array $words) 
    {
        $rows = self::lots([
            'l1.lang' => 'tw',
            'l1.title' => $words,
        ], ['l1.title(word)', 'm.id'], [
            '[><]' . self::fmTbl() . '(m)' => [
                'l1.parent_id' => 'id',
                'm.status' => '[SV]' . self::ST_ON,
            ],
        ], 500, 'lang(l1)');

        // 把 rows 跟 words 做差集，沒有 id 的 words 就進行寫入 
        $existingWords = array_column($rows, 'word');
        $newWords = array_diff($words, $existingWords);

        $insertedRows = [];
        foreach ($newWords as $word) {
            $pid = self::add([], [
                ['tw', [
                    'title' => $word,
                ]]
            ]);

            $insertedRows[] = [
                'word' => $word,
                'id'   => $pid,
                'new'   => 1,
            ];
        }

        return array_merge($rows, $insertedRows);
    }

    public static function autoBindTerms($target = 'press')
    {
        $target = ucfirst($target);
        $that   = '\\F3CMS\\f' . $target;
        $result = [
            'articles' => 0,
            'terms'    => 0,
            'linked'   => 0,
            'existing' => 0,
        ];
        $terms = self::lots([
            'm.status'   => self::ST_ON,
            'l.lang'     => 'tw',
            'l.title[!]' => '',
            'ORDER'      => ['m.id' => 'ASC'],
        ], ['m.id', 'l.title'], [
            '[>]' . self::fmTbl('lang') . '(l)' => ['m.id' => 'parent_id'],
        ]);
        $matchedArticles = [];
        $changedTags     = [];

        foreach ($terms as $term) {
            $articles = $that::lots([
                'm.status'     => ($target == 'Press') ? [$that::ST_PUBLISHED, $that::ST_CHANGED] : $that::ST_ON,
                'l.lang'       => 'tw',
                'l.content[~]' => $term['title'],
                'ORDER'        => ['m.id' => 'ASC'],
            ], ['m.id'], [
                '[>]' . $that::fmTbl('lang') . '(l)' => ['m.id' => 'parent_id'],
            ]);

            foreach ($articles as $row) {
                $matchedArticles[$row['id']] = true;

                if ($that::addRelated('tag', $row['id'], $term['id'])) {
                    $changedTags[$term['id']] = true;
                    $result['linked']++;
                } else {
                    $result['existing']++;
                }
            }
        }

        if ('Press' == $target) {
            foreach (array_keys($changedTags) as $tagId) {
                self::setPressCnt($tagId);
            }
        }

        $result['articles'] = count($matchedArticles);
        $result['terms']    = count($terms);

        return $result;
    }

    /**
     * @param $mainData
     * @param $lang
     * @return mixed
     */
    public static function add(array $mainData, array $lang)
    {
        $pid  = 0;
        $now  = date('Y-m-d H:i:s');
        $data = array_merge([
            'status'      => self::ST_ON,
            'slug'        => self::renderUniqueNo(16),
            'last_ts'     => $now,
            'insert_ts'   => $now,
            'insert_user' => fStaff::_current('id')
        ], $mainData);

        mh()->insert(self::fmTbl(), $data);
        $pid = mh()->id();

        if (self::chkErr($pid)) {
            self::saveLang($pid, $lang);
        }

        return $pid;
    }
}
