open Ctypes
  let bert_ctx = ptr void
  
  let bert_load = Foreign.foreign "bert_load_from_file" (string @-> returning bert_ctx)
  let bert_free = Foreign.foreign "bert_free" (bert_ctx @-> returning void)
 

type unconstructable = |

[@@boxed] external bind1 : unconstructable -> unit = "bert_load_from_file"
[@@boxed] external bind2 : unconstructable -> unit = "bert_free"