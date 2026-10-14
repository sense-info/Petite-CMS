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
    function findWord(array $words) {
        $rows = self::lots([
            'l1.lang' => 'tw',
            'l1.title' => $words,
        ], ['l1.title(word)', 'm.id'], [
            '[><]' . self::fmTbl() . '(m)' => [
                'l1.parent_id' => 'id',
                'm.status' => '[SV]' . self::ST_ON,
            ],
        ], 500, self::fmTbl('lang') . '(l1)');

        // 把 rows 跟 words 做差集，沒有 id 的 words 就進行寫入 
        $existingWords = array_column($rows, 'word');
        $newWords = array_diff($words, $existingWords);

        $acceptLang = fDraft::acceptLang();
        $insertedRows = [];

        foreach ($newWords as $word) {
            
            $pid = self::add([], [
                ['tw', [
                    'title' => $word,
                ]]
            ]);

            foreach ($acceptLang as $idx => $label) {
                if ($idx == 'tw') {
                    continue;
                }

                fDraft::add([
                    'lang' => $idx,
                    'row_id' => $pid,
                    'target' => 'Dictionary',
                    'intent' => '翻譯文章 (' . $pid . ') 為 ' . $label,
                    'guideline' => $word,
                    'method' => 'quicktrans'
                ]);
            }

            $insertedRows[] = [
                'word' => $word,
                'id'   => $pid,
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
