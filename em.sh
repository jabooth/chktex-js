econfigure ./configure
emake make
mv chktex chktex.bc
emcc chktex.bc -o chktex.js