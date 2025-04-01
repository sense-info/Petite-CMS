<?php

namespace F3CMS;

class rOption extends Reaction
{
    /**
     * @param $f3
     * @param $args
     */
    public function do_list($f3, $args)
    {
        kStaff::_chkLogin();

        $req = parent::_getReq();

        if (fStaff::_current('lang')) {
            f3()->set('acceptLang', \__::pluck(fStaff::_current('lang'), 'key'));
        }

        $req['page']  = (isset($req['page'])) ? ($req['page'] - 1) : 0;
        $req['query'] = (!isset($req['query'])) ? '' : $req['query'];

        $rtn    = fOption::limitRows($req['query'], $req['page'], 200);
        $groups = [];

        foreach ($rtn['subset'] as $row) {
            $groups[$row['group']]['title']  = $row['group'];
            $groups[$row['group']]['rows'][] = $row;
        }

        $rtn['subset'] = $groups;

        return parent::_return(1, $rtn);
    }

    /**
     * @param $f3
     * @param $args
     */
    public function do_get_group($f3, $args)
    {
        kStaff::_chkLogin();

        $req = parent::_getReq();

        $opts = fOption::limitRows('m.group~' . $req['group'], 1, 10);
        $rtn  = [];

        foreach ($opts['subset'] as &$row) {
            $rtn[] = ['id' => $row['name'], 'title' => $row['content']];
        }

        return parent::_return(1, $rtn);
    }

    /**
     * @param $f3
     * @param $args
     */
    public function do_get_counties($f3, $args)
    {
        $req = self::_getReq();

        if (!isset($req['query'])) {
            $req['query'] = '';
        }

        return self::_return(1, fOption::listCounties($req['query']));
    }

    /**
     * @param $f3
     * @param $args
     */
    public function do_zipcodes($f3, $args)
    {
        $req = self::_getReq();

        if (!isset($req['county'])) {
            $req['county'] = '';
        }

        return self::_return(1, fOption::loadZipcodes($req['county']));
    }

    public function do_categories($f3, $args)
    {
        $fc  = new FCHelper('categories');
        $rtn = $fc->get('categories', 30); // 1 mins

        if (empty($rtn)) {
            $rtn = fWork::categories();
            $fc->save('categories', jsonEncode($rtn));
        } else {
            $rtn = jsonDecode(preg_replace('/<!--(?!\s*(?:\[if [^\]]+]|<!|>))(?:(?!-->).)*-->/s', '', $rtn), true);
        }

        return self::_return(1, $rtn);
    }

    /**
     * 1. 史前時代-1367年
     * 2. 1368年-1682年 (明)
     * 3. 1683年-1894年 (清)
     * 4. 1895年-1944年 (日治)
     * 5. 1945年-1959年
     * 6. 1960年-1969年
     * 7. 1970年-1979年
     * 8. 1980年-1989年
     * 9. 1990年-1999年
     * 10. 2000年-2009年
     * 11. 2010年-迄今
     *
     **/

    // old, for gee.getChainOption v1
    function do_get_zipcodes($f3, $args)
    {
        $req = parent::_getReq();

        $zipcodes = fOption::loadZipcodes($req['pid']);

        $rtn = [];
        $rtn = '<option value="">請選擇</option>';
        foreach ($zipcodes as $value) {
            $rtn .= '<option value="' . $value['zipcode'] . '">' . $value['town'] . ' ' . $value['zipcode'] . '</option>';
        }

        echo $rtn;
        exit;
    }
}
