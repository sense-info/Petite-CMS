<?php

namespace F3CMS;

class Module
{
    /**
     * _escape
     *
     * @param mixed $array - obj need to escape
     *
     * @return mixed
     */
    protected static function _escape($array, $quote = true)
    {
        if (is_array($array)) {
            foreach ($array as $k => $v) {
                if (is_string($v)) {
                    if ($quote) {
                        $array[$k] = mh()->quote(self::protectedXss2($v));
                    } else {
                        $array[$k] = ('content' != $k) ? self::_mres(self::protectedXss2($v)) : self::_mres(PFHelper::getInstance()->purify(html_entity_decode($v)), false);
                    }
                } elseif (is_array($v)) {
                    $array[$k] = self::_escape($v, $quote);
                }
            }
        } else {
            if ($quote) {
                $array = mh()->quote(self::protectedXss2($array));
            } else {
                $array = self::_mres(self::protectedXss2($array));
            }
        }

        return $array;
    }

    static protected function _mres($param, $quote = true, $only_for_mssql = false)
    {
        // if(is_array($param))
        //     return array_map(__METHOD__, $param);

        if ($only_for_mssql && !empty($param) && is_string($param)) {
            if ($quote) {
                return str_replace(['\\', "\0", "'", '"', "\x1a"], ['\\\\', '\\0', "\\'", '\\"', '\\Z'], $param);
            } else {
                return str_replace(['\\', "\0", "\x1a"], ['\\\\', '\\0', '\\Z'], $param);
            }
        }

        return $param;
    }

    /**
     * @param $str
     */
    final static function protectedXss($str)
    {
        return htmlentities($str, ENT_QUOTES, 'UTF-8');
    }

    final static function protectedXss2($str)
    {
        $str = rawurldecode($str);

        return filter_var($str, FILTER_SANITIZE_SPECIAL_CHARS);
    }

    /**
     * @param $name
     * @param $target
     */
    public static function _shift($name, $target)
    {
        $name = str_replace(['F3CMS\\', '\\'], ['', ''], $name);

        [$type, $className] = preg_split('/(?<=[fork])(?=[A-Z])/', $name);

        return '\\F3CMS\\' . \F3CMS_Autoloader::getPrefix()[$target] . $className;
    }

    /**
     * handle angular post data
     *
     * @return array - post data
     */
    public static function _getReq()
    {
        $rtn = [];

        if (1 == f3()->get('isCORS')) {
            $str = f3()->get('BODY');
            if (empty($str)) {
                $str = file_get_contents('php://input');
            }

            $rtn = json_decode($str, true);
            if (!(JSON_ERROR_NONE == json_last_error())) {
                parse_str($str, $rtn);
            }
        }

        if (empty($rtn)) {
            $rtn = f3()->get('POST');
        }

        if (empty($rtn)) {
            $rtn = f3()->get('GET');
        }

        if (empty($rtn)) {
            $rtn = f3()->get('REQUEST');
        }

        return self::_escape($rtn, false);
    }

    /**
     * @param array $args
     */
    public static function _lang($args = [])
    {
        $acceptLang = f3()->get('acceptLang');
        if (1 == count($acceptLang)) {
            return f3()->get('defaultLang');
        } elseif (isset($_SERVER['HTTP_X_BACKEND_LANG'])) {
            $lang = $_SERVER['HTTP_X_BACKEND_LANG'];
            if (!in_array($lang, $acceptLang)) {
                $lang = f3()->get('defaultLang');
            }

            return $lang;
        } else {
            if (!f3()->exists('lang') || !empty($args)) {
                $lang = f3()->get('defaultLang');

                if (f3()->exists('COOKIE.user_lang')) {
                    $lang = f3()->get('COOKIE.user_lang');
                }

                if (isset($_SERVER['HTTP_CUSTOMER_LANG'])) {
                    $lang = $_SERVER['HTTP_CUSTOMER_LANG'];
                }

                if (!empty($args) && !empty($args['lang'])) {
                    $lang = $args['lang'];
                }

                if (f3()->exists('REQUEST.lang') && !empty(f3()->get('REQUEST.lang'))) {
                    $lang = f3()->get('REQUEST.lang');
                }

                if (!in_array($lang, $acceptLang)) {
                    $lang = f3()->get('defaultLang');
                }

                f3()->set('lang', $lang);
            }
        }

        return f3()->get('lang');
    }

    /**
     * @return mixed
     */
    public static function _mobile_user_agent()
    {
        if (!f3()->exists('device')) {
            $device = 'unknown';

            if (stristr($_SERVER['HTTP_USER_AGENT'], 'ipad')) {
                $device = 'ipad';
            } elseif (stristr($_SERVER['HTTP_USER_AGENT'], 'iphone') || strstr($_SERVER['HTTP_USER_AGENT'], 'iphone')) {
                $device = 'iphone';
            } elseif (stristr($_SERVER['HTTP_USER_AGENT'], 'blackberry')) {
                $device = 'blackberry';
            } elseif (stristr($_SERVER['HTTP_USER_AGENT'], 'android')) {
                $device = 'android';
            }

            f3()->set('device', $device);
        } else {
            $device = f3()->get('device');
        }

        return $device;
    }

    /**
     * @param $text
     *
     * @return mixed
     */
    public static function _slugify($text)
    {
        $text = str_replace('//', '/', $text);
        $text = str_replace(' ', '-', $text);

        // replace non letter or digits by -
        $text = preg_replace('~[^\\pL\d%/-]+~u', '-', $text);

        // trim
        $text = trim($text, '-');

        // transliterate
        // $text = iconv('utf-8', 'us-ascii//TRANSLIT', $text);

        // lowercase
        $text = strtolower($text);

        // remove unwanted characters
        // $text = preg_replace('~[^-\w]+~', '', $text);
        //
        $text = urlencode($text);

        if (empty($text)) {
            return 'n-a';
        }

        return $text;
    }

    /**
     * detect a class file exist
     *
     * @param string $pClassName Name of the object to load
     */
    public static function _exists($pClassName)
    {
        $className = ltrim($pClassName, '\\');
        $fileName  = '';
        $namespace = '';
        if ($lastNsPos = strrpos($className, '\\')) {
            $namespace = substr($className, 0, $lastNsPos);
            $className = substr($className, $lastNsPos + 1);
            $fileName  = str_replace('\\', DIRECTORY_SEPARATOR, $namespace) . DIRECTORY_SEPARATOR;
        }

        [$type, $moduleName] = preg_split('/(?<=[fork])(?=[A-Z])/', $className);

        if (null !== $moduleName) {
            $fileName .= str_replace('_', DIRECTORY_SEPARATOR, $moduleName) . DIRECTORY_SEPARATOR . \F3CMS_Autoloader::getType()[$type] . '.php';

            $fileName = str_replace('libs', 'modules', __DIR__) . str_replace('F3CMS', '', $fileName);

            if (false === file_exists($fileName)) {
                $fileName = str_replace('/f3cms', '', $fileName);
            }
        } else {
            $fileName .= str_replace('_', DIRECTORY_SEPARATOR, $type) . '.php';
            $fileName = __DIR__ . str_replace('F3CMS', '', $fileName);
        }

        if ((false === file_exists($fileName)) || (false === is_readable($fileName))) {
            return false;
        }

        return true;
    }
}
