<?php

// autoload.php

class F3CMS_Autoloader
{
    public static function Register()
    {
        if (function_exists('__autoload')) {
            spl_autoload_register('__autoload');
        }
        if (version_compare(PHP_VERSION, '5.3.0') >= 0) {
            return spl_autoload_register(['F3CMS_Autoloader', 'Load'], true, true);
        } else {
            return spl_autoload_register(['F3CMS_Autoloader', 'Load']);
        }
    }

    public static function getType()
    {
        return [
            'f' => 'feed',
            'o' => 'outfit',
            'r' => 'reaction',
            'k' => 'kit',
        ];
    }

    public static function getPrefix()
    {
        return [
            'feed'     => 'f',
            'outfit'   => 'o',
            'reaction' => 'r',
            'kit'      => 'k',
        ];
    }

    /**
     * Autoload a class identified by name
     *
     * @param string $pClassName Name of the object to load
     */
    public static function Load($pClassName)
    {
        $fileName = self::detect($pClassName);
        if (false !== $fileName) {
            require $fileName;
        }
    }

    /**
     * detect a class file exist
     *
     * @param string $pClassName Name of the object to load
     */
    public static function detect($pClassName)
    {
        if (class_exists($pClassName, false) || (0 !== strpos($pClassName, 'F3CMS'))) {
            return false;
        }

        $className = ltrim($pClassName, '\\');
        $fileName  = '';
        $namespace = '';
        if ($lastNsPos = strrpos($className, '\\')) {
            $namespace = substr($className, 0, $lastNsPos);
            $className = substr($className, $lastNsPos + 1);
            $fileName  = str_replace('\\', DIRECTORY_SEPARATOR, $namespace) . DIRECTORY_SEPARATOR;
        }

        if (preg_match('/(^[fork])+([A-Z]\S*)/', $className, $match)) {
            $type       = $match[1];
            $moduleName = $match[2];

            $fileName .= str_replace('_', DIRECTORY_SEPARATOR, $moduleName) . DIRECTORY_SEPARATOR . self::getType()[$type] . '.php';

            // use $webRootDir first
            $fileName1 = str_replace('F3CMS', f3()->get('web_dir') . 'modules', $fileName);

            $fileName2 = str_replace('libs', 'modules', __DIR__) . str_replace('F3CMS', '', $fileName);

            $fileName = (file_exists($fileName1)) ? $fileName1 : $fileName2;
        } else {
            $fileName .= str_replace('_', DIRECTORY_SEPARATOR, $className) . '.php';
            $fileName = __DIR__ . str_replace('F3CMS', '', $fileName);
        }

        if ((false === file_exists($fileName)) || (false === is_readable($fileName))) {
            return false;
        }

        return $fileName;
    }
}

F3CMS_Autoloader::Register();
