
open Ocamlggmlbert
open Owl_pretty
open Owl.Dense.Ndarray


let () = let m = Bert.load "./ggml-model-f32.bin" in 
["That is a happy person"; "That is a happy dog"; "That is a very happy person"; "Today is a sunny day"]
|> List.map (Bert.encode m)
|> Array.of_list
|> S.concatenate
|> S.transpose
|> S.dot (Bert.encode m (input_line stdin))
|> print_dsnda; Bert.free m
