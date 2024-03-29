let parse = ref false

let compile arg =
  let channel = open_in arg in
  let tokens   = Lexing.from_channel channel in
  let e = Parser.prog Lexer.token tokens in
  if !parse then
    Lang.string_of_exp e |> print_endline
  else
  begin 
    ignore(Lang.typecheck [] e);
    Lang.interpret e |> Lang.string_of_val |> print_endline
  end

let main () =
  begin
    let speclist = [("-parse", Arg.Set parse, "prints the abstract syntax tree generated by the parser.")]
    in let usage_msg = "Usage: ./compiler.native [flags] [file]" in
    Arg.parse speclist compile usage_msg;
  end

let _ = if !Sys.interactive then () else main ()
