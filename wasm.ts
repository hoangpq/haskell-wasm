#!/usr/bin/env -S deno run --allow-read --allow-write --v8-flags=--experimental-wasm-return_call,--no-liftoff,--wasm-lazy-compilation,--wasm-lazy-validation
import fs from "node:fs"
import WasiContext from "https://deno.land/std/wasi/snapshot_preview1.ts";

const context = new WasiContext({});
const encoder = new TextEncoder("utf-8");

const instance = (
  await WebAssembly.instantiate(fs.readFileSync("hello.wasm"), {
    wasi_snapshot_preview1: context.exports,
  })
).instance;

context.initialize(instance);
instance.exports.hs_init(0, 0);

const memory = instance.exports.memory;
const mem = new Uint8Array(memory.buffer);

const buf = encoder.encode('Vampire!');
const ptr = instance.exports.mallocBytes(buf.length);
mem.set(buf, ptr);

// will print Hello, <name> in the console
instance.exports.hello(ptr);
const buf2 = encoder.encode('Hoang Phan!');
const ptr2 = instance.exports.mallocBytes(buf2.length);
mem.set(buf2, ptr2);
instance.exports.hello(ptr2);
