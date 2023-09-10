
open Ocamlggmlbert
open Owl_pretty

let () = let m = Bert.load "./ggml-model-f32.bin" in print_dsnda (Bert.encode m "Hello, world!"); Bert.free m
