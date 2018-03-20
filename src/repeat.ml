let length = ref false
let print arg =
  if !length then
    Printf.printf "%d\n" (String.length arg)
  else
    Printf.printf "%s\n" arg
let main =
begin
let speclist = [("-length", Arg.Set length, "prints the lengths of the arguments")]
in let usage_msg = "Usage: my-project [flags] [args]"
in Arg.parse speclist print usage_msg;
end

let () = main

