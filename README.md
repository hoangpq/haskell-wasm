# haskell-wasm

## Getting started
[ghc-wasm-meta](https://gitlab.haskell.org/ghc/ghc-wasm-meta)

```bash
$ wasm32-wasi-ghc hello.hs -o hello.wasm -no-hs-main -optl-mexec-model=reactor -optl-Wl,--export=hs_init,--export=hello,--export=mallocBytes,--export=free,--export=h_eval

$ chmod +x wasm.ts && ./wasm.ts
```
