#!/usr/bin/env sh

set -e

cd $(dirname "$0")

_ext='so'
case "$(uname)" in
  MINGW*) _ext='dll';;
esac

gcc load.c -o load -ldl

for std in '08' '93'; do

  echo "> [$std] Analyze tb.vhd"
  ghdl -a --std="$std" tb.vhd

  echo ""

  for item in 'pass' 'fail'; do
    echo "> [$std] Build tb-${item}.${_ext}"
    ghdl -e --std="$std" -shared -Wl,-fPIC -Wl,main.c tb ${item}
    echo ""

    echo "> [$std] C load and run tb-${item}.${_ext}"
    ./load "./tb-${item}.${_ext}"
    echo ""

    echo "> [$std] Python load and run tb-${item}.${_ext}"
    python3 -c 'from pyaux import run; run("./tb-'"${item}.${_ext}"'", 0, None)'
    echo ""
  done

done

rm -rf *.o *."${_ext}" *.cf
