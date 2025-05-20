<?php

namespace F3CMS;

/**
 * kit lib
 */
class kDraft extends Kit
{
    public static function writing($content, $guideline)
    {
        return self::_formatRePly(OpenAi::answer([['content' => $fixedPrompt, 'reply' => '']], '', 0, 16384));
    }

    public static function layout($content)
    {
        return self::_formatRePly(OpenAi::answer([['content' => $fixedPrompt, 'reply' => '']], '', 0, 16384));
    }

    public static function expertDiscussion($content)
    {
        return self::_formatRePly(OpenAi::answer([['content' => $fixedPrompt, 'reply' => '']], '', 0, 16384));
    }

    public static function guideline($content)
    {
        return self::_formatRePly(OpenAi::answer([['content' => $fixedPrompt, 'reply' => '']], '', 0, 16384));
    }

    public static function seohelper($content)
    {
        return self::_formatRePly(OpenAi::answer([['content' => $fixedPrompt, 'reply' => '']], '', 0, 16384));
    }

    public static function translate($lang, $content)
    {
        $reply = OpenAi::answer([['content' => $txt, 'reply' => '']], $format, 0, 16384);

        if ($lang == 'ko') {
            $reply = str_replace([' '], [' '], $reply);
        }

        return self::_formatRePly($reply);
    }

    private static function _formatRePly($reply = '')
    {
        return $reply;
    }
}
