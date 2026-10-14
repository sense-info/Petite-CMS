<?php

namespace F3CMS;

/**
 * data feed
 */
class fPost extends Feed
{
    const MTB    = 'post';
    const ST_ON  = 'Enabled';
    const ST_OFF = 'Disabled';

    const PV_R = 'mgr.site';
    const PV_U = 'mgr.site';
    const PV_D = 'mgr.site';

    const BE_COLS = 'm.id,l.title,m.status,m.slug,m.cover,m.last_ts';

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
            'from_ai' => 'Yes',
        ];

        if (!empty($data['title'])) {
            $updates['title'] = $data['title'];
        }

        if (!empty($data['content'])) {
            $updates['content'] = $data['content'];
        }

        $data = mh()->update(self::fmTbl('lang'), $updates, [
            'parent_id' => $pid,
            'lang'      => $lang,
        ]);

        return parent::chkErr($data->rowCount());
    }

    public static function emptyI18nContent($pid, $lang)
    {
        $data = mh()->update(self::fmTbl('lang'), [
            'content' => '',
        ], [
            'parent_id' => $pid,
            'lang'      => $lang,
            'from_ai'   => 'Yes',
        ]);

        return parent::chkErr($data->rowCount());
    }
}
