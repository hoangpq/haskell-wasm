wasm32-wasi-ghc hello.hs -o hello.wasm \
	-no-hs-main -optl-mexec-model=reactor \
	-optl-Wl,--export=hs_init,--export=hello,--export=mallocBytes,--export=free,--export=h_eval

# optimize wasm binary for size
wasm-opt -Oz -o hello_1.wasm hello.wasm
