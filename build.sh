#! /bin/sh
#
#     ---- Build script for chktex.js. ----
#
# On UNIX boxes with Emscripten installed on them, this should just work.
#
# To create a release build of chktex.js
#
#   ./build.sh
#
# If all goes well running
#
#   ./chktex.js --version
#
# Should work.
#  
# To generate debug builds for development, try:
#
#   ./build.sh --dev
#
# This will include source maps that I've found work in VSCode's node debugger 
# (see .vscode/launch.json for an example of how to debug). It will also disable
# Emscripten optimisations that will make debugging easier.
#
# 
# If you have trouble running this script, you can try explicitly running 
#
#   ./configure-js.sh
#
# To create a Makefile and then
# 
#   ./make-js.sh 
#
# To have emscripten run it.
#
# The resulting commands the above will generate will very likely be the same
# As what is presented below, and will take a fair while (and scan for perl,
# latex and all sorts of stuff on your system), hence this simple build script.
FLAGS='-DHAVE_CONFIG_H -DSYSCONFDIR="/usr/local/etc" -D__unix__'
CFLAGS='-O3'
if [ "$1" == "--dev" ]; then
  echo "---------- BUILDING DEVELOPMENT VERSION OF CHKTEX.JS -----------------"
  CFLAGS='-g4'
else
  echo "---------- BUILDING RELEASE VERSION OF CHKTEX.JS ---------------------"
fi
CFLAGS="$CFLAGS -Wstrict-prototypes -Wall"

echo "---------- 1/3 Cleaning existing files... ----------------------------"
rm *.bc chktex.js*
echo "---------- 2/3 Building... -------------------------------------------"
trap 'exit' ERR  # bail on error
set -x  # show the executed command
emcc $FLAGS $CFLAGS -c ChkTeX.c -o ChkTeX.bc
emcc $FLAGS $CFLAGS -c FindErrs.c -o FindErrs.bc
emcc $FLAGS $CFLAGS -c OpSys.c -o OpSys.bc
emcc $FLAGS $CFLAGS -c Resource.c -o Resource.bc
emcc $FLAGS $CFLAGS -c Utility.c -o Utility.bc
emcc $CFLAGS -o chktex.js ChkTeX.bc FindErrs.bc OpSys.bc Resource.bc Utility.bc --pre-js ./pre.js --memory-init-file 0 --embed-file chktexrc@/usr/local/etc/
set +x  # show the executed command
echo "---------- 3/3 Converting to executable... ---------------------------"
echo "#!/usr/bin/env node" | cat - chktex.js > /tmp/out && mv /tmp/out chktex.js
chmod u+x chktex.js
echo "---------- Finished. Testing binary... -------------------------------"
./chktex.js --version
if [ "$1" != "--dev" ]; then
  echo "---------- Cleaning up (build a --dev build to stop this) ------------"
  rm *.bc
fi
