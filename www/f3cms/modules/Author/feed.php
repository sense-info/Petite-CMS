<?php

namespace F3CMS;

/**
 * data feed
 */
class fAuthor extends Feed
{
    const MTB    = 'author';
    const ST_ON  = 'Enabled';
    const ST_OFF = 'Disabled';

    const BE_COLS = 'm.id,l.title,m.status,m.slug,m.cover,m.last_ts';
}
