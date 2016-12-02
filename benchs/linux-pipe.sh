#!/bin/bash

. tools/jobs.sh

extract_results() {
    awk '/>===.*/ {
        capture = 1
    }
    /<===.*/ {
        capture = 0
    }
    /^[^<>].*/ {
        if(capture == 1)
            print $0
    }'
}

cd xtensa-linux

./b mkapps
./b mklx
./b mkbr

run() {
    jobs_started

    mkdir -p $1/lx-$3
    BENCH_CMD="$2" GEM5_OUT=$1/lx-$3 GEM5_CP=1 LX_CORES=2 ./b bench
    extract_results < $1/lx-$3/res.txt > $1/lx-$3-output.txt
}

jobs_init $2

datasize=$((512 * 1024))

for comp in 32000 64000 128000 256000 512000; do
    jobs_submit run $1 "/bench/bin/execpipe 3 2 4 1 0 /bench/bin/pipewr $datasize $comp /bench/bin/piperd $comp" "equal-${comp}"
    jobs_submit run $1 "/bench/bin/execpipe 3 2 4 1 0 /bench/bin/pipewr $datasize $comp /bench/bin/piperd 1000" "fastread-${comp}"
    jobs_submit run $1 "/bench/bin/execpipe 3 2 4 1 0 /bench/bin/pipewr $datasize 1000 /bench/bin/piperd $comp" "fastwrite-${comp}"
done

jobs_wait
