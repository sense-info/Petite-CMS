<?php

namespace F3CMS;

class rPress extends Reaction
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
        $row['books']     = fPress::lotsBook($row['id']);

        // read history file
        // $fc = new FCHelper('press');
        $row['history']        = []; // $fc->getLog('press_' . $row['id']);
        $row['status_publish'] = $row['status'];

        return $row;
    }

    /**
     * @param $f3
     * @param $args
     */
    public function do_list($f3, $args)
    {
        kStaff::_chkLogin();

        $req = parent::_getReq();

        $req['page'] = ($req['page']) ? ($req['page'] - 1) : 1;

        $rtn = fPress::limitRows($req['query'], $req['page']);

        foreach ($rtn['subset'] as $k => $row) {
            $rtn['subset'][$k]['tags']    = fPress::lotsTag($row['id']);
            $rtn['subset'][$k]['authors'] = fPress::lotsAuthor($row['id']);
        }

        return self::_return(1, $rtn);
    }

    /**
     * @param $f3
     * @param $args
     */
    public function do_published($f3, $args)
    {
        kStaff::_chkLogin();

        $req = parent::_getReq();

        $cu = fPress::one($req['id']);

        if (empty($cu)) {
            return parent::_return(8106);
        }

        switch ($req['status']) {
            case fPress::ST_PUBLISHED:
                // TODO: add config to control this
                // $req['online_date'] = date('Y-m-d H:i:00', time() - 60); // DONT use local datetime

                if (0 === f3()->get('cache.press')) {
                    oPress::buildPage(['slug' => $cu['id']]);
                }
                break;
            case fPress::ST_OFFLINED:
                // TODO: remove file when offlined
                break;
            default:
                break;
        }

        fPress::published($req);

        return self::_return(1, ['id' => $req['id']]);
    }

    /**
     * @param $f3
     * @param $args
     */
    public function do_more($f3, $args)
    {
        $query = [
            'm.status' => [fPress::ST_PUBLISHED, fPress::ST_CHANGED],
        ];

        $req = parent::_getReq();

        $req['page'] = ($req['page']) ? ($req['page'] - 1) : 1;

        $req['limit'] = max(min($req['limit'] * 1, 24), 3);

        if (!empty($req['pid'])) {
            if (is_numeric($req['pid'])) {
                $tag = fTag::one($req['pid'], 'id', ['status' => fTag::ST_ON], false);
            } else {
                $tag = fTag::one(parent::_slugify($req['pid']), 'slug', ['status' => fTag::ST_ON], false);
            }
        } else {
            $tag = null;
        }

        if (!empty($req['query'])) {
            if (is_string($req['query'])) {
                $query['l.title[~]'] = urldecode(str_replace('q=', '', $req['query']));
            } else {
                if (!empty($req['query']['sub_tag'])) {
                    if (!is_array($req['query']['sub_tag'])) {
                        $req['query']['sub_tag'] = explode(',', $req['query']['sub_tag']);
                    }
                    $tags = array_merge($tags, fTag::bySlug($req['query']['sub_tag']));
                }

                if (!empty($req['query']['q'])) {
                    $query['l.title[~]'] = $req['query']['q'];
                }
            }
        }

        if (!empty($tag)) {
            $rtn = fPress::lotsByTag($tag['id'], $req['page'], $req['limit']);
        } else {
            // if (!empty($req['columnID'])) {
            //     if ($req['columnType'] == 'topic') {
            //         $query .= ',m.topic_id:' . intval($req['columnID']);
            //     } else {
            //         $query .= ',m.column_id:' . intval($req['columnID']);
            //     }
            // }
            $rtn = fPress::limitRows($query, $req['page'], $req['limit']);
        }

        foreach ($rtn['subset'] as $k => $row) {
            $rtn['subset'][$k]['tags'] = fPress::lotsTag($row['id']);
            $rtn['subset'][$k]['authors'] = fPress::lotsAuthor($row['id']);
        }

        return self::_return(1, $rtn);
    }
}
