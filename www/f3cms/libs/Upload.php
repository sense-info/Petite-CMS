<?php

namespace F3CMS;

use Intervention\Image\Drivers\Imagick\Driver;
use Intervention\Image\ImageManager as Image;

class Upload extends Helper
{
    /**
     * @param       $files
     * @param array $thumbnail
     * @param       $column
     */
    public static function savePhoto($files, $thumbnail = [], $column = 'photo', $acceptable = [])
    {
        $root    = rtrim(f3()->get('abspath'), '/'); // f3()->get('ROOT') . f3()->get('BASE'); //
        $path    = '/upload/img/' . date('Y/m') . '/';
        $current = $files[$column];

        $acceptable = (!empty($acceptable)) ? $acceptable : f3()->get('photo_acceptable');

        if (($current['size'] >= f3()->get('maxsize')) || (0 == $current['size'])) {
            Reaction::_return('2002', ['msg' => 'File too large(' . $current['size'] . '). File must be less than ' . f3()->get('maxsize') . '.']);
        }

        if (!in_array($current['type'], $acceptable) && !empty($current['type'])) {
            Reaction::_return('2003', ['msg' => 'Invalid file type. Only JPG, GIF and PNG types are accepted(' . $current['type'] . ').']);
        }

        if (0 != $current['error']) {
            Reaction::_return('2004', ['msg' => 'other error.']);
        }

        if (!FSHelper::mkdir($root . $path) || !is_writable($root . $path)) {
            Reaction::_return('2006', ['msg' => 'failed to mkdir(' . $root . $path . ').']);
        }

        $path_parts = pathinfo($current['name']);
        $old_fn     = $path_parts['filename'];
        $ext        = $path_parts['extension'];

        $filename = $path . substr(md5(uniqid(microtime(), 1)), 0, 15);

        if (file_exists($current['tmp_name'])) {
            $manager = Image::withDriver(new Driver());

            $im = $manager->read($current['tmp_name']);

            $webpable = self::is_webpable($current['type']);

            $width  = $im->width();
            $height = $im->height();

            if ($width > 1440) {
                $im->save($root . $filename . '_ori.' . $ext); // save original img

                // resizing to default size
                $im->scale(width: 1440);
            }

            // TODO: watermark
            // $im->insert('public/watermark.png', 'bottom-right', 10, 10);

            $im->save($root . $filename . '.' . $ext);
            if ($webpable) {
                self::webp($root . $filename . '.' . $ext);
            }

            $im->scale(width: 720);

            $im->save($root . $filename . '_md.' . $ext);
            if ($webpable) {
                self::webp($root . $filename . '_md.' . $ext);
            }

            $im->scale(width: 360);

            $im->save($root . $filename . '_sm.' . $ext);
            if ($webpable) {
                self::webp($root . $filename . '_sm.' . $ext);
            }

            // smaller then 360
            foreach ($thumbnail as $ns) {
                // cropping and resizing
                $im->cover($ns[0], $ns[1]);

                $im->save($root . $filename . '_' . $ns[0] . 'x' . $ns[1] . '.' . $ext);
                if ($webpable) {
                    self::webp($root . $filename . '_' . $ns[0] . 'x' . $ns[1] . '.' . $ext);
                }
            }

            $new_fn = $filename . '.' . $ext;

            if ($webpable && 'develop' != f3()->get('APP_ENV')) {
                $new_fn = str_replace('.' . $ext, '.webp', $new_fn);
                $new_fn .= '?' . $ext;
            }
        } else {
            $new_fn = '';
            $width  = 0;
            $height = 0;
        }

        return [$new_fn, $width, $height, $old_fn];
    }

    /**
     * @param       $files
     * @param array $acceptable
     *
     * @return mixed
     */
    public static function saveFile($files, $acceptable = [], $column = 'file')
    {
        $root    = f3()->get('ROOT') . f3()->get('BASE');
        $path    = '/upload/doc/' . date('Y/m') . '/';
        $current = $files[$column];

        $acceptable = (!empty($acceptable)) ? $acceptable : f3()->get('file_acceptable');

        if (($current['size'] >= f3()->get('maxsize')) || (0 == $current['size'])) {
            Reaction::_return('2002', ['msg' => 'File too large(' . $current['size'] . '). File must be less than ' . f3()->get('maxsize') . '.']);
        }

        if (!in_array($current['type'], $acceptable) || empty($current['type'])) {
            Reaction::_return('2003', ['msg' => 'Invalid file type.(' . $current['type'] . ')']);
        }

        if (0 != $current['error']) {
            Reaction::_return('2004', ['msg' => 'other error.']);
        }

        if (!FSHelper::mkdir($root . $path) || !is_writable($root . $path)) {
            Reaction::_return('2006', ['msg' => 'failed to mkdir.']);
        }

        $path_parts = pathinfo($current['name']);
        $old_fn     = $path_parts['filename'];
        $ext        = $path_parts['extension'];

        $filename = $path . substr(md5(uniqid(microtime(), 1)), 0, 15);

        if (move_uploaded_file($current['tmp_name'], $root . $filename . '.' . $ext)) {
            $new_fn = $filename . '.' . $ext;
        } else {
            $new_fn = '';
        }

        return $new_fn;
    }

    /**
     * @param $uri
     *
     * @return mixed
     */
    public static function takeScreenshot($uri)
    {
        $root = f3()->get('ROOT') . f3()->get('BASE');
        $path = '/upload/screenshot/' . date('Y/m') . '/';

        if (!FSHelper::mkdir($root . $path) || !is_writable($root . $path)) {
            Reaction::_return('2006', ['msg' => 'failed to mkdir.']);
        }

        $filename = $path . substr(md5(uniqid(microtime(), 1)), 0, 15);
        $fp       = fopen($root . $filename . '.png', 'w+b');

        $params = [
            'key'     => f3()->get('screenshot_key'),
            'size'    => Screenshot::SIZE_F,
            'url'     => $uri,
            'format'  => Screenshot::PNG,
            'timeout' => 1000,
        ];

        $ss  = new Screenshot($params);
        $raw = $ss->saveScreen($fp);
        fclose($fp);

        return $filename . '.png';
    }

    /**
     * adapter for PHPExcel
     *
     * @param string $filename -
     * @param int    $startRow -
     * @param int    $endRow   -
     * @param array  $columns  -
     *
     * @return array
     */
    public static function readExcel($filename, $startRow, $endRow, $columns)
    {
        $root = f3()->get('ROOT') . f3()->get('BASE');

        // include_once $root . f3()->get('vendors') . 'PHPExcel/IOFactory.php';

        $inputFileName = $root . '' . $filename;

        $filterSubset = new XlsReadFilter($startRow, $endRow, $columns);

        try {
            $inputFileType = PHPExcel_IOFactory::identify($inputFileName);

            $objReader = PHPExcel_IOFactory::createReader($inputFileType);
            $objReader->setReadDataOnly(true);
            $objReader->setReadFilter($filterSubset);
            $objPHPExcel = $objReader->load($inputFileName);

            return $objPHPExcel->getActiveSheet()->toArray(null, true, true, true);
        } catch (PHPExcel_Reader_Exception $e) {
            Reaction::_return('2005', str_replace($root, '', $e->getMessage()));
        }
    }

    /**
     * scan folder
     *
     * @param string $dir
     * @param int    $only_dir -only folder type or all
     * @param string $target   -target column name or all
     *
     * @return array
     */
    public static function scan($dir = '', $only_dir = 0, $target = 'all')
    {
        $root = f3()->get('ROOT') . f3()->get('BASE');

        $files = [];

        // Is there actually such a folder/file?
        if (file_exists($root . $dir)) {
            foreach (scandir($root . $dir) as $f) {
                if (!$f || '.' == $f[0]) {
                    continue; // Ignore hidden files
                }

                if (is_dir($root . $dir . '/' . $f)) {
                    if (1 == $only_dir || 0 == $only_dir) {
                        // The path is a folder
                        $files[] = [
                            'name'  => $f,
                            'type'  => 'folder',
                            'path'  => $dir . '/' . $f,
                            'items' => self::scan($dir . '/' . $f, $only_dir), // Recursively get the contents of the folder
                        ];
                    }
                } else {
                    // It is a file
                    if (2 == $only_dir || 0 == $only_dir) {
                        $tmp = [
                            'name' => $f,
                            'type' => 'file',
                            'path' => $dir . '/' . $f,
                            'size' => filesize($root . $dir . '/' . $f), // Gets the size of this file
                        ];

                        if ('all' == $target) {
                            $files[] = $tmp;
                        } else {
                            $files[] = $tmp[$target];
                        }
                    }
                }
            }
        }

        return $files;
    }

    /**
     * @param $source
     * @param $dist
     * @param $width
     * @param $height
     */
    public static function resizGif($source, $dist, $width = 600, $height = 600)
    {
        $imagick = new Imagick($source);

        $imagick = $imagick->coalesceImages();
        do {
            $imagick->resizeImage($width, $height, Imagick::FILTER_BOX, 1);
        } while ($imagick->nextImage());

        $imagick = $imagick->deconstructImages();

        $imagick->writeImages($dist, true);

        $imagick->clear();
        $imagick->destroy();
    }

    /**
     * @param $path
     *
     * @return mixed
     */
    public static function webp($path)
    {
        if (file_exists($path)) {
            try {
                $logger     = new \Log('convert.log');
                $path_parts = pathinfo($path);
                $ext        = $path_parts['extension'];

                $ta    = str_replace('.' . $ext, '.webp', $path);
                $ratio = 60;
                $sh    = 'convert ' . $path . ' -quality ' . $ratio . ' -define webp:lossless=false,method=6,auto-filter=true,partitions=3,image-hint=photo ' . $ta . ';';

                $logger->write($sh);
                shell_exec($sh);

                $path = $ta;
            } catch (Exception $e) {
                $logger = new \Log('convert_error.log');
                $logger->write('failed convert to webp:' . $path);
            }
        }

        return $path;
    }

    /**
     * @param $mimeType
     */
    public static function is_webpable($mimeType)
    {
        $taMimeTypes = [
            'image/jpeg',
            'image/png',
        ];

        return in_array($mimeType, $taMimeTypes);
    }
}
