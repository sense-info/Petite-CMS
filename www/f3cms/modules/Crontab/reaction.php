<?php

namespace F3CMS;

class rCrontab extends Reaction
{
    public static function do_job()
    {
        $freq  = f3()->get('PARAMS.freq');
        $tally = f3()->get('PARAMS.tally');

        $worker = [];

        $data = fCrontab::many($freq, $tally);

        f3()->get('cliLogger')->write('Info - ' . $freq . '::' . $tally);

        if (count($data) > 0) {
            foreach ($data as $k => $loopJob) {
                if (!empty($loopJob['module'])) {
                    f3()->get('cliLogger')->write('Info - ' . $loopJob['module'] . '::' . $loopJob['method']);
                    $worker[$k] = new Worker($loopJob['module'], $loopJob['method']);
                    $worker[$k]->startWorker();
                }
            }
        }
    }
}
