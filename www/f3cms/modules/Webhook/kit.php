<?php

namespace F3CMS;

/**
 * kit lib
 */
class kWebhook extends Kit
{
    public static function rules()
    {
        return [
            'getPress'  => [
                'press_id'   => 'required',
            ],
        ];
    }
}
