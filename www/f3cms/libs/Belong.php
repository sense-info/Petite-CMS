<?php

namespace F3CMS;

trait Belong
{
    public static function bind($subTbl, $target_id, $member_id = 0)
    {
        [$that, $sub, $pk, $fk] = self::_init(get_called_class(), $subTbl);

        if (0 == $member_id) {
            $member_id = fMember::_CMember();
        }

        $related = mh()->get($that::fmTbl($subTbl) . '(r)', [
            '[>]' . $that::fmTbl() . '(t)'       => ['r.' . $pk => 'id'],
        ], ['t.id', 'r.status'], [
            'r.member_id' => $member_id,
            'r.' . $pk    => $target_id,
        ]);

        if ($related) {
            if ('claps' == $subTbl) {
                mh()->update($that::fmTbl($subTbl), [
                    'cnt[+]' => 1,
                ], [
                    'member_id' => $member_id,
                    $pk         => $target_id,
                    'cnt[<]'    => 100, // TODO: use fOption
                ]);
            } elseif ('hits' == $subTbl) {
                mh()->update($that::fmTbl($subTbl), [
                    'cnt[+]' => 1,
                ], [
                    'member_id' => $member_id,
                    $pk         => $target_id,
                ]);
            } else {
                if ('Enabled' == $related['status'] && 'seen' != $subTbl) {
                    mh()->update($that::fmTbl($subTbl), [
                        'status' => 'Disabled',
                    ], [
                        'member_id' => $member_id,
                        $pk         => $target_id,
                    ]);
                }
            }
        } else {
            mh()->insert($that::fmTbl($subTbl), [
                'member_id' => $member_id,
                $pk         => $target_id,
                'status'    => 'Enabled',
                'insert_ts' => date('Y-m-d H:i:s'),
            ]);
        }

        if (in_array($subTbl, ['seen', 'favo'])) {
            $that::setCnt($subTbl, $target_id);
        }

        if ('claps' == $subTbl) {
            $that::setClapCnt($target_id);
        }
    }

    public static function setClapCnt($pid)
    {
        [$that, $sub, $pk, $fk] = self::_init(get_called_class(), 'member');

        $cnt = mh()->get($that::fmTbl('claps'), ['cnt' => MHelper::raw('SUM(<cnt>)')], [$pk => $pid]);
        $cnt = ($cnt) ? $cnt['cnt'] * 1 : 0;

        $rtn = mh()->update($that::fmTbl(), [
            'claps' => $cnt,
        ], [
            'id' => $pid,
        ]);

        return $that::chkErr($rtn->rowCount());
    }

    /**
     * two type
     * one with sub table
     * the other without sub table
     *
     * TODO: from sub to main
     **/
    public static function setCnt($pid, $subTbl = 'video', $filter = [], $type = 0)
    {
        [$that, $sub, $pk, $fk] = self::_init(get_called_class(), $subTbl);

        switch ($type) {
            case 1:
                $cnt = $sub::total(
                    array_merge([$pk => $pid], $filter),
                    null, '', 'COUNT(<' . $pk . '>)');
                break;
            default:
                $cnt = $that::total(
                    array_merge([$pk => $pid], $filter),
                    null, $subTbl, 'COUNT(<' . $pk . '>)');
                break;
        }

        $rtn = mh()->update($that::fmTbl(), [
            $subTbl . '_cnt' => $cnt,
        ], [
            'id' => $pid,
        ]);

        return $that::chkErr($rtn->rowCount());
    }

    /**
     * @param $ta_tbl
     * @param $pid
     * @param $reverse
     */
    public static function lotsSub($subTbl, $pid, $columns = ['t.id', 'title'])
    {
        [$that, $sub, $pk, $fk] = self::_init(get_called_class(), $subTbl);

        $filter = [$pk => $pid];

        $join = $sub::genJoin();

        if (!$join) {
            $join = [];
        }
        $join['[>]' . $sub::fmTbl() . '(t)'] = ['r.' . $fk => 'id'];

        return mh()->select(
            $that::fmTbl($subTbl) . '(r)',
            $join,
            $columns,
            $filter
        );
    }

    /**
     * @param $id
     * @param $page
     * @param $limit
     * @param $cols
     *
     * @return mixed
     */
    public static function lotsByTag($id, $page = 0, $limit = 6, $cols = '')
    {
        $that = get_called_class();

        return $that::lotsByID($that::byTag($id), $page, $limit, $cols);
    }

    /**
     * @param $id
     *
     * @return array
     */
    public static function byTag($id)
    {
        $that = get_called_class();

        if (is_array($id)) {
            $condi = [];
            foreach ($id as $row) {
                $condi[] = ' SELECT `' . $that::MTB . '_id` FROM `' . $that::fmTbl('tag') . '` WHERE `tag_id`=' . intval($row) . ' ';
            }

            $rows = mh()->query('SELECT `' . $that::MTB . '_id`, COUNT(`' . $that::MTB . '_id`) AS `cnt` FROM (' . implode(' UNION ALL ', $condi) . ') u GROUP by `' . $that::MTB . '_id` HAVING `cnt` > ' . (count($condi) - 1) . ' ')->fetchAll(\PDO::FETCH_ASSOC);
        } else {
            $rows = mh()->select($that::fmTbl('tag') . '(r)', ['r.' . $that::MTB . '_id'], ['r.tag_id' => $id]);
        }

        return \__::pluck($rows, '' . $that::MTB . '_id');
    }

    /**
     * @param       $subTbl
     * @param       $pid
     * @param array $rels
     * @param       $reverse
     *
     * @return int
     */
    public static function saveMany($subTbl, $pid, $rels = [], $reverse = false, $sortable = false)
    {
        if (empty($rels)) {
            return false;
        }

        [$that, $sub, $pk, $fk] = self::_init(get_called_class(), $subTbl);

        $data = [];

        if ($reverse) {
            [$fk, $pk] = [$pk, $fk];
        }

        mh()->delete($that::fmTbl($subTbl), [$pk => $pid]);

        foreach ($rels as $idx => $value) {
            if (!empty($value)) {
                $data[$idx] = [
                    $pk => $pid,
                    $fk => $value,
                ];

                if ($sortable) {
                    $data[$idx]['sorter'] = $idx;
                }
            }
        }

        if (!empty($data)) {
            mh()->insert($that::fmTbl($subTbl), $data);
        }

        return 1;
    }

    private static function _init($that, $subTbl)
    {
        // $that = get_called_class();
        $sub  = '\F3CMS\f' . ucfirst($subTbl);

        $pk = $that::MTB . '_id';
        $fk = $subTbl . '_id';

        return [$that, $sub, $pk, $fk];
    }
}
