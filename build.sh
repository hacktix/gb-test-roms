#!/usr/bin/env bash

cd -- "$(dirname -- "$0")"

docker build . -t gb-test-roms


build_toolchains="\
cd /src/rgbds && make &&\
cd /src/rgbds-4 && make &&\

cd /src/wla-dx &&\
	mkdir build && cd build &&\
	cmake .. && cmake --build . --config Release &&\

echo done \
"

docker run \
	-v ./:/src:rw \
	-it gb-test-roms \
	sh -c "$build_toolchains"


build_roms="\
mkdir -p /src/out/blargg &&\
cd /src/blargg-gb-roms && find . -name '*.gb' -exec rsync -R {} /src/out/blargg \; >/dev/null &&\

mkdir -p /src/out/sm83 &&\
cd /src/singlestep-sm83-tests && cp v1/* /src/out/sm83 &&\

cd /src/rgbds-4 && make install &&\

mkdir -p /src/out/acid &&\
cd /src/dmg-acid2 && make && cd build && find . -name '*.gb' -exec rsync -R {} /src/out/acid \; >/dev/null &&\
cd /src/cgb-acid2 && make && cd build && find . -name '*.gbc' -exec rsync -R {} /src/out/acid \; >/dev/null &&\

mkdir -p /src/out/mealybug &&\
cd /src/mealybug-gb-tests && make && cd build && find . -name '*.gb' -exec rsync -R {} /src/out/mealybug \; >/dev/null &&\

cd /src/rgbds && make install &&\

mkdir -p /src/out/samesuite &&\
cd /src/samesuite-gb-tests && make && find . -name '*.gb' -exec rsync -R {} /src/out/samesuite \; >/dev/null &&\

cd /src/wla-dx/build && cmake -P cmake_install.cmake &&\

mkdir -p /src/out/mooneye &&\
cd /src/mooneye-gb-tests && make && cd build && find . -name '*.gb' -exec rsync -R {} /src/out/mooneye \; >/dev/null &&\

mkdir -p /src/out/wilbertpol &&\
cd /src/wilbertpol-gb-tests/tests && make && cd build && find . -name '*.gb' -exec rsync -R {} /src/out/wilbertpol \; >/dev/null &&\

echo done \
"

docker run \
	-v ./:/src:rw \
	-it gb-test-roms \
	sh -c "$build_roms"
