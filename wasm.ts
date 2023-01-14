import WasiContext from "https://deno.land/std/wasi/snapshot_preview1.ts";

const context = new WasiContext({});

const encoder = new TextEncoder("utf-8");

const instance = (
  await WebAssembly.instantiate(await Deno.readFile("hello.wasm"), {
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
