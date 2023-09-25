
open Ocamlggmlbert
open Owl.Dense.Ndarray
open Core
open In_channel

let () = 
let argv = Sys.get_argv() in 
let m = Bert.load (Array.get argv 1) in
let lines = input_lines stdin in
List.filter lines ~f:(fun x ->  phys_equal x "" |> not )
|> List.map ~f:(Bert.encode m)
|> Array.of_list
|> S.concatenate
|> S.transpose
|> S.dot (Bert.encode m (Array.get argv 2))
|> S.argsort
|> Generic.to_array
|> Array.to_list
|> List.zip_exn lines
|> List.sort ~compare:( fun (_,x) (_,y) ->  Int64.compare x y)
|> List.iter ~f:(fun (s,v) -> print_string (String.concat [Int64.to_string v; "\t"; s; "\n"]))