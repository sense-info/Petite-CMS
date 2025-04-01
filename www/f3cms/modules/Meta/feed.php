<?php

namespace F3CMS;

/**
 * data feed
 */
class fMeta extends Feed
{
    const MTB        = 'meta';
    const MULTILANG  = 0;
    const BRANCHMODE = 1;

    const PV_R = 'mgr.site';
    const PV_U = 'mgr.site';
    const PV_D = 'mgr.site';

    const ST_ON  = 'Enabled';
    const ST_OFF = 'Disabled';

    /**
     * @param $tag_id
     *
     * @return mixed
     */
    public static function load($tag_id = '')
    {
        $filter = [
            'status' => self::ST_ON,
        ];

        if ('' != $tag_id) {
            $filter['tag_id'] = $tag_id;
        }

        $filter = self::branchSite($filter);

        $rows = mh()->select(self::fmTbl(), '*', $filter);

        $metas = [];

        foreach ($rows as $row) {
            if ('' != $tag_id) {
                $metas[$row['fence']] = $row;
            } else {
                $metas[$row['tag_id']][$row['fence']] = $row;
            }
        }

        return $metas;
    }

    /**
     * @param $pid
     * @param $reverse
     */
    public static function lotsGenus($pid)
    {
        $pk = self::MTB . '_id';
        $fk = 'tag_id';

        $filter = [
            'r.' . $pk => $pid,
        ];

        return mh()->select(self::fmTbl('tag') . '(r)',
            ['[>]' . fGenus::fmTbl('lang') . '(t)'  => ['r.tag_id' => 'parent_id', 'l.lang' => '[SV]' . Module::_lang()]],
            ['[><]' . fGenus::fmTbl() . '(g)'       => ['r.tag_id' => 'id', 'g.status' => '[SV]' . fGenus::ST_ON]],
            // '[>]' . fTag::fmTbl('lang') . '(l)' => ['t.id' => 'parent_id', 'l.lang' => '[SV]' . Module::_lang()]],
            ['r.tag_id(id)', 't.title'], $filter);
    }

    /**
     * @param $queryStr
     *
     * @return mixed
     */
    public static function genQuery($queryStr = '')
    {
        $query = parent::genQuery($queryStr);

        if (array_key_exists('all', $query)) {
            $query['OR']['fence[~]'] = $query['all'];
            $query['OR']['label[~]'] = $query['all'];
            unset($query['all']);
        }

        if (array_key_exists('all[!]', $query)) {
            $query['AND']['fence[!]'] = $query['all[!]'];
            $query['AND']['label[!]'] = $query['all[!]'];
            unset($query['all[!]']);
        }

        if (array_key_exists('all[!~]', $query)) {
            $query['AND']['fence[!~]'] = $query['all[!~]'];
            $query['AND']['label[!~]'] = $query['all[!~]'];
            unset($query['all[!~]']);
        }

        return $query;
    }

    /**
     * @param $query
     * @param $page
     * @param $limit
     */
    public static function limitRows($query = '', $page = 0, $limit = 12, $cols = '')
    {
        $filter = self::genQuery($query);

        $filter['ORDER'] = ['m.sorter' => 'ASC', 'm.fence' => 'ASC'];

        $join = [
            '[>]' . fStaff::fmTbl() . '(s)' => ['m.last_user' => 'id'],
            // '[>]' . fTag::fmTbl('lang') . '(l)' => array('m.tag_id' => 'parent_id', 'l.lang' => '[SV]'. Module::_lang())
        ];

        return parent::paginate(self::fmTbl() . '(m)', $filter, $page, $limit, ['m.id', 'm.sorter', 'm.fence', 'm.status', 'm.ps', 'm.label', 'm.type', 'm.input', 's.account'], $join);
    }
}
