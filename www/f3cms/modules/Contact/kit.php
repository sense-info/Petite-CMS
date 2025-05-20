<?php

namespace F3CMS;

/**
 * kit lib
 */
class kContact extends Kit
{
    public static function rules()
    {
        return [
            'add_new' => [
                'name'    => 'required|max:250',
                'email'   => 'required|email|max:250',
                // 'mobile'  => 'required|min:6|max:16',
                // 'subject' => 'required|max:250',
                // 'company' => 'required|max:250',
                'message' => 'required|max:250',
            ],
        ];
    }
}
