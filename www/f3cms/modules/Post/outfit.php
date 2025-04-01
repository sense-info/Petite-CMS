<?php

namespace F3CMS;

/**
 * for render page
 */
class oPost extends Outfit
{
    /**
     * @param $args
     */
    public static function home($args)
    {
        parent::render('index.twig', '首頁', '/home');
    }

    /**
     * @param $args
     */
    public static function sitemap($args)
    {
        $subset = fPress::limitRows([
            'm.status' => [fPress::ST_PUBLISHED, fPress::ST_CHANGED],
        ], 0, 1000);

        f3()->set('rows', $subset);
        f3()->set('page', fOption::load('page'));

        self::_echoXML('sitemap');
    }

    /**
     * @param $args
     */
    public static function rss($args)
    {
        $subset = fPress::limitRows([
            'm.status' => [fPress::ST_PUBLISHED, fPress::ST_CHANGED],
        ], 0, 1000);

        $subset['subset'] = \__::map($subset['subset'], function ($cu) {
            $cu['authors'] = fPress::lotsAuthor($cu['id']);

            if (!empty($cu['authors'])) {
                $cu['authors'] = implode(', ', \__::pluck($cu['authors'], 'title'));
            } else {
                $cu['authors'] = '';
            }

            return $cu;
        });

        f3()->set('rows', $subset);

        f3()->set('page', fOption::load('page'));
        f3()->set('contact_mail', fOption::get('contact_mail'));

        self::_echoXML('rss');
    }

    /**
     * @param $f3
     * @param $args
     */
    public function do_lineXml($f3, $args)
    {
        if (!f3()->get('connectLineXml')) {
            exit('403 Forbidden');
        }

        // TODO: is LINE connention?

        $subset = fPress::limitRows([
            'm.status' => [fPress::ST_PUBLISHED, fPress::ST_CHANGED],
        ], 0, 100, ',l.content');

        $subset['subset'] = \__::map($subset['subset'], function ($cu) {
            $cu['authors'] = fPress::lotsAuthor($cu['id']);

            if (!empty($cu['authors'])) {
                $cu['authors'] = implode(', ', \__::pluck($cu['authors'], 'title'));
            } else {
                $cu['authors'] = '';
            }

            $cu['keyword'] = fPress::lotsTag($cu['id'], true);

            if (!empty($cu['keyword'])) {
                $cu['keyword'] = implode(', ', \__::pluck($cu['keyword'], 'title'));
            } else {
                $cu['keyword'] = '';
            }

            $cu['online_ts'] = strtotime($cu['online_date']) . '000';
            $cu['online_ts'] = strtotime($cu['last_ts']) . '000';

            return $cu;
        });

        f3()->set('rows', $subset);

        f3()->set('page', fOption::load('page'));
        f3()->set('time', time() . '000');
        f3()->set('contact_mail', fOption::get('contact_mail'));

        self::_echoXML('lineXml');
    }

    /**
     * @param $args
     */
    public static function show($args)
    {
        $row = fPost::one($args['slug'], 'slug', ['status' => fPost::ST_ON], 0);

        if (empty($row)) {
            f3()->error(404);
        }

        if ('chunyichang' == f3()->get('theme')) {
            $row['subtitle'] = $row['slug'];
        }

        f3()->set('cu', $row);
        f3()->set('act_link', strtolower($args['slug']));

        f3()->set('breadcrumb_sire', ['title' => '首頁', 'slug' => '/home']);

        parent::wrapper('/post.html', $row['title'], '/s/' . $row['slug']);
    }

    /**
     * @param $args
     */
    public static function about($args)
    {
        $args['slug'] = 'about';
        self::show($args);
    }

    /**
     * @param $args
     */
    public static function privacy($args)
    {
        $args['slug'] = 'privacy';
        self::show($args);
    }

    /**
     * @param $args
     */
    public static function comingsoon($args)
    {
        $ts  = strtotime(f3()->get('siteBeginDate'));
        $now = time();
        if ($now < $ts) {
            parent::wrapper('comingsoon.html', 'Coming Soon', '/comingsoon');
        } else {
            f3()->reroute('/home');
        }
    }

    /**
     * @param $args
     */
    public static function notfound($args)
    {
        f3()->set('ERROR', [
            'code' => '404',
            'text' => 'Not Found',
        ]);

        parent::wrapper('/error.html', 'Not Found', '/404');
    }

    /**
     * @param $args
     */
    public static function word($args)
    {
        $phpWord = WHelper::init();
        $page    = $phpWord->newPage();

        $cert = $phpWord->newCert('三思資訊');
        $page->addImage($cert, [
            'wrappingStyle' => 'behind',
            'width'         => 637,
            'height'        => 923,
            'marginTop'     => -1,
            'marginLeft'    => -1,
        ]);

        // \PhpOffice\PhpWord\Shared\Html::addHtml($section, '<table style="width:100%"><tr><td><img src="https://www.gettyimages.ca/gi-resources/images/Homepage/Hero/UK/CMS_Creative_164657191_Kingfisher.jpg" width="200"/></td><td>text</td></tr></table>');

        // $header = $page->addHeader();
        // $header->addWatermark(f3()->get('ROOT') . f3()->get('BASE') . '/upload/img/bg.png', array('marginTop' => 200, 'marginLeft' => 55));

        // $fontStyleName = 'oneUserDefinedStyle';
        // $phpWord->addFontStyle(
        //     $fontStyleName,
        //     array('name' => 'Tahoma', 'size' => 10, 'color' => '1B2232', 'bold' => true)
        // );

        // $textbox = $page->addTextBox(
        //     array(
        //         'alignment'   => \PhpOffice\PhpWord\SimpleType\Jc::CENTER,
        //         'width'       => 400,
        //         'height'      => 150,
        //         'borderSize'  => 1,
        //         // 'borderColor' => '#FF0000',
        //         'background-color' => '#FF0000'
        //     )
        // );
        // $textbox->addText('Text box content in section.');
        // $textbox->addText('Another line.');

        // $page->addText(
        //     '"Learn from yesterday, live for today, hope for tomorrow. '
        //         . 'The important thing is not to stop questioning." '
        //         . '(Albert Einstein)',
        //     $fontStyleName
        // );

        // $page->addText(
        //     '"Great achievement is usually born of great sacrifice, '
        //         . 'and is never the result of selfishness." '
        //         . '(Napoleon Hill)',
        //     $fontStyleName
        // );

        // $page->addTextBreak(2);

        // $page->addText(
        //     '"The greatest accomplishment is not in never falling, '
        //         . 'but in rising again after you fall." '
        //         . '(Vince Lombardi)',
        //     $fontStyleName
        // );

        $phpWord->done('certification_' . date('YmdHis') . '.odt');
        // $phpWord->done('certification_' . date('YmdHis').'.docx', 'Word2007');
    }
}
