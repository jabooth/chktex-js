#! /bin/sh
# if ./build.sh doesn't work for you for some reason
# run this to actually let Emscripten run the ./configure script
# to make a Makefile...
EXTRA_CONFIG_ARGS='CFLAGS=-O3'
if [ "$1" == "--dev" ]; then
  echo "Building development version"
  EXTRA_CONFIG_ARGS=''
fi

echo "\n\n------------------------ 1/1 Invoking emconfigure... ------------------------------"
trap 'exit' ERR  # bail on error
set -x  # show the executed command
emconfigure ./configure  --disable-debug-info --disable-pcre $EXTRA_CONFIG_ARGS
