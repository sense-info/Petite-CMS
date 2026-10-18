<?php

namespace F3CMS;

/**
 * data feed
 */
class fDictionary extends Feed
{
    const MTB    = 'dictionary';
    const ST_ON  = 'Enabled';
    const ST_OFF = 'Disabled';

    const BE_COLS = 'm.id,l.title,m.status,m.slug,m.cover,m.last_ts';

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

    /**
     * 自資料庫（dictionary 表）中自動搜尋並比對與文章內容相符的專有名詞譯名
     *
     * @param mixed $txtAry
     * @return array [中文名詞 => 目標譯名]
     */
    public static function fetchMatchedGlossary($txtAry): array
    {
        $matchedGlossary = [];

        $rows = self::lots([
            'l1.lang' => 'tw',
            'l1.title' => $txtAry,
        ], ['l1.title(word)', 'l2.title(trans)'], [
            '[><]' . self::fmTbl() . '(m)' => [
                'l1.parent_id' => 'id',
                'm.status' => '[SV]' . self::ST_ON,
            ],
            '[><]' . self::fmTbl('lang') . '(l2)' => [
                'l1.parent_id' => 'parent_id',
                'l2.lang' => '[SV]'  . Module::_lang()
            ],
        ], 500, self::fmTbl('lang') . '(l1)');

        if (!empty($rows)) {
            foreach ($rows as $row) {
                $matchedGlossary[$row['word']] = $row['trans'];
            }
        }

        return $matchedGlossary;

        /**
         * 試試這個版本的效能

            $query = "SELECT word, translation FROM dictionary
            WHERE lang = :langCode
            AND :flattenText LIKE CONCAT('%', word, '%')
            AND translation IS NOT NULL";

            $stmt = self::$db->query($query, [
                ':langCode' => $langCode,
                ':flattenText' => $flattenText
            ]);
         */

    }

    public static function importTranslations(array $rows)
    {
        $headers = ['中文', '英文', '日文', '韓文'];
        $result  = [
            'inserted' => 0,
            'skipped'  => 0,
            'invalid'  => 0,
            'errors'   => [],
        ];

        if (empty($rows) || $headers !== array_slice($rows[0], 0, 4)) {
            $result['errors'][] = 'CSV 標題必須為：中文,英文,日文,韓文';

            return $result;
        }

        foreach (array_slice($rows, 1) as $index => $row) {
            $line = $index + 2;
            $row  = array_map('trim', array_slice($row, 0, 4));

            if (4 !== count($row) || in_array('', $row, true)) {
                $result['invalid']++;
                $result['errors'][] = '第 ' . $line . ' 列資料不完整';
                continue;
            }

            list($tw, $en, $ja, $ko) = $row;
            $exists = mh()->get(self::fmTbl('lang'), 'parent_id', [
                'lang'  => 'tw',
                'title' => $tw,
            ]);

            if (!empty($exists)) {
                $result['skipped']++;
                continue;
            }

            $pid      = 0;
            $imported = false;
            mh()->action(function ($mh) use ($tw, $en, $ja, $ko, &$pid, &$imported) {
                $pid = self::add([
                    'slug'      => parent::_slugify($en),
                    'last_user' => fStaff::_current('id'),
                ], [
                    ['tw', ['title' => $tw]],
                    ['en', ['title' => $en]],
                    ['ja', ['title' => $ja]],
                    ['ko', ['title' => $ko]],
                ], $mh);

                $imported = !empty($pid) && !$mh->error();

                return $imported;
            });

            if (!$imported) {
                $result['errors'][] = '第 ' . $line . ' 列寫入失敗';
                continue;
            }

            $result['inserted']++;
        }

        return $result;
    }

    /**
     * @param $mainData
     * @param $lang
     * @return mixed
     */
    public static function add(array $mainData, array $lang, $mh = null)
    {
        $mh   = $mh ?: mh();
        $pid  = 0;
        $now  = date('Y-m-d H:i:s');
        $data = array_merge([
            'status'      => self::ST_ON,
            'slug'        => self::renderUniqueNo(16),
            'last_ts'     => $now,
            'insert_ts'   => $now,
            'insert_user' => fStaff::_current('id')
        ], $mainData);

        $mh->insert(self::fmTbl(), $data);
        $pid = $mh->id();

        if (self::chkErr($pid, $mh)) {
            self::saveLang($pid, $lang, $mh);
        }

        return $pid;
    }

    public static function autoBindTerms($target = 'press')
    {
        $target = ucfirst($target);
        $that = '\\F3CMS\\f' . $target;

        $result = [
            'articles'  => 0,
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

                if ($that::addRelated('term', $row['id'], $term['id'])) {
                    $result['linked']++;
                } else {
                    $result['existing']++;
                }
            }
        }

        $result['articles'] = count($matchedArticles);
        $result['terms']   = count($terms);

        return $result;
    }
}
