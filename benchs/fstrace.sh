#!/bin/bash

cd xtensa-linux

# ./b mklx
# ./b mkapps
# ./b mkbr
# LX_THCMP=1 ./b fsbench > $1/lx-fstrace-30cycles.txt

gen_timedtrace() {
    grep -B10000 "===" $1 | grep -v "===" > $1-strace
    grep -A10000 "===" $1 | grep -v "===" > $1-timings
    ./tools/timedstrace.php $1-strace $1-timings > $1-timedstrace
}

gen_timedtrace $1/lx-fstrace-30cycles.txt

cd -
cd m3/XTSC
export M3_TARGET=t3 M3_BUILD=bench M3_FS=bench.img

./b

./build/t3-sim-bench/apps/fstrace/strace2cpp/strace2cpp \
    < $1/lx-fstrace-30cycles.txt-timedstrace > $1/lx-fstrace-30cycles.txt-opcodes.c
cp $1/lx-fstrace-30cycles.txt-opcodes.c apps/fstrace/m3fs/trace.c

./b run boot/fstrace.cfg
./tools/bench.sh xtsc.log > $1/m3-fstrace.txt
