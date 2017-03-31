#! /bin/sh
# if ./build.sh doesn't work for you for some reason
# run this to actually let Emscripten run the Makefile.
# Note you need to run ./configure-js.sh first with a matching
# --dev flag (either provide to both or omit from both).
CFLAGS='-O3'
if [ "$1" == "--dev" ]; then
  echo "Building development version"
  CFLAGS='-g4'
fi

echo "---------------------- Cleaning existing artifacts... ----------------------"
make clean
rm chktex.bc chktex.js* chktex.data a.out*

trap 'exit' ERR  # From here on out bail on error

echo "\n\n------------------------ 1/2 Invoking emake make... ------------------------"
emmake make

echo "\n\n------------------------ 2/2 Invoking emcc... ------------------------------"
# Disable seperate .mem file to keep everything self contained.
mv chktex chktex.bc
set -x
emcc $CFLAGS chktex.bc -o chktex.js --pre-js ./pre.js --memory-init-file 0 --embed-file chktexrc@/usr/local/etc/
set +x
echo "\n\n--------------------- Attempting to run binary ----------------------------"
node chktex.js --version
