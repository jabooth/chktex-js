#! /bin/sh
emconfigure ./configure  --disable-debug-info --disable-pcre 'CFLAGS=-O3'
make clean
emmake make
mv chktex chktex.bc
emcc -O3 chktex.bc -o chktex.js
node chktex.js --version
