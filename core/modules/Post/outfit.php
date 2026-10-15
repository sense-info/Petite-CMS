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
    public function do_backend($f3, $args)
    {
        $f3->set('jsrender_code', '<script id="menuTmpl" type="text/x-jsrender">{{props data}} <a class="navbar-item" {{if prop.blank == \'Yes\' }} href="{{:prop.uri}}" target="_blank" {{else}} href="javascript:;" func="loadApp" data-app="{{:prop.uri}}" data-pid="{{:prop.id}}" {{/if}} >{{:prop.title}}</a> {{/props}}</script> <script id="submenuTmpl" type="text/x-jsrender">{{props data}} <li class="item"><a {{if prop.blank == \'Yes\' }} href="{{:prop.uri}}" target="_blank" {{else}} {{if prop.query }} href="javascript:;" func="loadModuleQuery" data-uri="{{:prop.uri}}" data-query="{{:prop.query}}" {{else}} href="javascript:;" func="loadMain" data-uri="{{:prop.uri}}" {{/if}} {{/if}} > <span class="icon"><i class="fa fa-{{:prop.icon}}"></i></span><span class="name">{{:prop.title}}</span></a></li> {{/props}}</script> <script id="menuTabTmpl" type="text/x-jsrender"><div class="tabs" data-func="toggleTab" data-ta="tabs-menu"><ul> {{props data}} <li> <a href="javascript:;" data-ta="tab-menu-{{:prop.id}}"> #{{:prop.id}} {{:prop.title}} </a> <!-- <a href="javascript:;" class="btn" data-func="loadRow" data-tmpl="menuForm" data-id="{{:prop.id}}"><span class="icon"><i class="fa fa-pencil"></i></span></a> --> </li> {{/props}} </ul></div> <div class="tabs-content box" id="tabs-menu" > {{props data}} <div class="tab-box" id="tab-menu-{{:prop.id}}"> <ul class="sortable" data-parent="{{:prop.id}}" data-menu-id="{{:prop.id}}">{{include prop tmpl="#menuListTmpl" /}}</ul> </div> {{/props}} </div></script> <script id="menuListTmpl" type="text/x-jsrender">{{props rows}} <li class="sortable-block loop-item" data-id="{{:prop.id}}"> <div class="level hover-highlight"> <div class="level-left"> {{if prop.rows.length > 0 }} <div class="level-item" data-func="menu/toggleFold" ><i class="fa fa-angle-down"></i></div> {{/if}} <div class="level-item js-sortable-handle"><i class="fa fa-random"></i></div> <div class="level-item menu-name"><small class="is-disabled">#{{:prop.id}}</small> {{:prop.title}}　<span class="tag {{if prop.status == \'Disabled\' }}is-warning{{/if}}">{{:~txtLabel(prop.status, {\'Enabled\': \'啟用\', \'Disabled\': \'未啟用\'})}}</span>　<small class="is-disabled ellipsis" style="max-width: 27vw;">{{:prop.uri}}</small></div> </div> <div class="level-right"> <div class="level-item"> <div class="field has-addons"> <p class="control"> <a href="javascript:;" class="button is-info" data-func="loadRow" data-tmpl="menuForm" data-id="{{:prop.id}}"> 編輯 </a> </p> <p class="control"> <a href="javascript:;" class="button is-danger" data-func="delRow" data-id="{{:prop.id}}"> 刪除 </a> </p> </div> </div> </div> </div> <ul class="sortable" data-parent="{{:prop.id}}">{{include prop tmpl="#menuListTmpl" /}}</ul> </li> {{/props}}</script>');

        parent::wrapper('../backend.html', '後台系統', '/backend');
    }

    /**
     * @param $args
     */
    public function do_robots($f3, $args)
    {
        echo \Template::instance()->render('robots.html', 'text/plain');
    }

    /**
     * @param $args
     */
    public static function sitemapxml($args)
    {
        $subset = fPress::limitRows([
            'm.status' => [fPress::ST_PUBLISHED, fPress::ST_CHANGED],
        ], 0, 1000);

        // ISO 639 Language Code (either 2 or 3 letters); see: http://www.loc.gov/standards/iso639-2/php/code_list.php
        // Exception: For Chinese, please use zh-cn for Simplified Chinese or zh-tw for Traditional Chinese. Required.
        $lang = parent::_lang();
        if ($lang == 'tw') {
            $lang = 'zh-tw';
        }

        f3()->set('language', $lang);
        f3()->set('rows', $subset);
        f3()->set('page', fOption::load('page'));

        $categories = fCategory::limitRows([
            'm.status' => fCategory::ST_ON,
        ], 0, 20, ',m.insert_ts');

        f3()->set('categories', $categories);

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
     * @param $args
     */
    public static function lineXml($args)
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
    public static function _render($args)
    {
        $row = fPost::one(parent::_slugify($args['slug']), 'slug', ['status' => fPost::ST_ON], 0);

        if (empty($row)) {
            f3()->error(404);
        }

        _dzv('cu', $row);

        f3()->set('breadcrumb_sire', ['title' => '首頁', 'slug' => '/home']);

        if ($row['layout'] == 'na') {
            die('此頁面非一般單頁，無法開啟');
        }

        $args['layout'] = (isset($args['layout'])) ? $args['layout'] : $row['layout'];
        // $args['slug']   = (isset($args['slug'])) ? $args['slug'] : 's/' . $row['slug'];

        parent::render('post/' . $args['layout'] . '.twig', $row['title'], '/s/' . $args['slug']);
    }

    /**
     * @param $args
     */
    public static function about($args)
    {
        $args['slug'] = 'about';
        self::_render($args);
    }

    /**
     * @param $args
     */
    public static function privacy($args)
    {
        $args['slug'] = 'privacy';
        self::_render($args);
    }

    /**
     * @param $args
     */
    public static function terms($args)
    {
        $args['slug'] = 'terms';
        self::_render($args);
    }

    /**
     * @param $args
     */
    public static function sitemap($args)
    {
        $args['slug'] = 'sitemap';
        parent::render($args);
    }

    /**
     * @param $args
     */
    public static function maintenance($args)
    {
        parent::wrapper('../maintenance.html', 'Maintenance, Coming Soon', '/maintenance');
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
        _dzv('ERROR', [
            'code' => '404',
            'text' => 'Not Found',
        ]);

        parent::render('error.twig', 'Not Found', '/404');
    }
}
