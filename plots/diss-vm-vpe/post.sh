#!/bin/bash

. tools/helper.sh

mhz=`get_mhz $1/m3-vpe-clone-0-0-1/output.txt`

gen_data() {
    echo "Lx M3-A M3-B M3-C M3-C*"

    for s in 1 $((1024 * 2048)) $((1024 * 4096)) $((1024 * 8192)); do
        lx=`./tools/m3-bench.sh time 1234 $mhz 1 < $1/lx-$2-$s/gem5.log`
        m320=`./tools/m3-bench.sh time 0001 $mhz 1 < $1/m3-vpe-$2-2-0-$s/gem5.log`
        m300=`./tools/m3-bench.sh time 0001 $mhz 1 < $1/m3-vpe-$2-0-0-$s/gem5.log`
        m312=`./tools/m3-bench.sh time 0001 $mhz 1 < $1/m3-vpe-$2-1-2-$s/gem5.log`
        m310=`./tools/m3-bench.sh time 0001 $mhz 1 < $1/m3-vpe-$2-1-0-$s/gem5.log`

        echo "$lx $m320 $m300 $m312 $m310"
    done
}

gen_stddev() {
    for s in 1 $((1024 * 2048)) $((1024 * 4096)) $((1024 * 8192)); do
        lx=`./tools/m3-bench.sh stddev 1234 $mhz 1 < $1/lx-$2-$s/gem5.log`
        m320=`./tools/m3-bench.sh stddev 0001 $mhz 1 < $1/m3-vpe-$2-2-0-$s/gem5.log`
        m300=`./tools/m3-bench.sh stddev 0001 $mhz 1 < $1/m3-vpe-$2-0-0-$s/gem5.log`
        m312=`./tools/m3-bench.sh stddev 0001 $mhz 1 < $1/m3-vpe-$2-1-2-$s/gem5.log`
        m310=`./tools/m3-bench.sh stddev 0001 $mhz 1 < $1/m3-vpe-$2-1-0-$s/gem5.log`

        echo "$lx $m320 $m300 $m312 $m310"
    done
}

for t in clone exec; do
    echo "Generating $1/$t-times.dat..."
    gen_data   $1 $t > $1/$t-times.dat
    echo "Generating $1/$t-stddev.dat..."
    gen_stddev $1 $t > $1/$t-stddev.dat
done
