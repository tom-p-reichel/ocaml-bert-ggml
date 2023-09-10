open Ctypes
open Foreign
open Owl.Dense.Ndarray
  


module RawBindings = struct 
  let bert_ctx = ptr void
  let bert_load = foreign "bert_load_from_file" (string @-> returning bert_ctx)
  let bert_free = foreign "bert_free" (bert_ctx @-> returning void)
  let bert_n_embed = foreign "bert_n_embd" (bert_ctx @-> returning int32_t)
  let bert_n_max_tokens = foreign "bert_n_max_tokens" (bert_ctx @-> returning int32_t)
  
  let bert_encode = foreign "bert_encode" (bert_ctx @-> int32_t @-> string @-> (ptr float) @-> returning void)


  type unconstructable = |
  [@@boxed] external bind1 : unconstructable -> unit = "bert_load_from_file"
  [@@boxed] external bind2 : unconstructable -> unit = "bert_free"
  [@@boxed] external bind3 : unconstructable -> unit = "bert_n_embd"
  [@@boxed] external bind4 : unconstructable -> unit = "bert_n_max_tokens"
  [@@boxed] external bind5 : unconstructable -> unit = "bert_encode"

end


type bert = {ctx : unit ptr ; n_embed : int32; n_max_tokens : int32; freed : bool }


let load filename = 
  let b = RawBindings.bert_load filename in
  {ctx = b; n_embed = RawBindings.bert_n_embed b; n_max_tokens = RawBindings.bert_n_max_tokens b; freed = false}


let free b = match b.freed with
  | false -> RawBindings.bert_free b.ctx
  | true -> ()


(* bert is a normal imperative memory construct. it needs to be explicitly unloaded, which isn't very functional!
   so we have this wrapper that loads and always unloads for you. *)
let enter filename f = 
  let b = load filename in
  let cleanup () = free b in
    Fun.protect ~cleanup (fun _ -> f b)


let encode b s = 
  let output_buffer = CArray.make float (Int32.to_int b.n_embed) in 
    RawBindings.bert_encode b.ctx (Int32.of_int 4) s (CArray.start output_buffer); 
    S.init [| (Int32.to_int b.n_embed) |] (fun i -> CArray.get output_buffer i)
