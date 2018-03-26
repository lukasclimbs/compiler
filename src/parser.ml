open Lang
open Lexer

let rec peek : token list -> token = List.hd
let rec advance : token list -> token list = List.tl

let rec consume (t:token) (tkns:token list) : token list =
  match tkns with
  | t' :: tkns ->
    if t = t' then
      tkns
    else
      failwith(Printf.sprintf "Expected '%s', found '%s'" (string_of_token t) (string_of_token t'))
  | _ -> failwith "Encountered unexpected end of token stream"

let rec parse (tkns:token list) : (exp * token list) =
  if List.length tkns = 0 then
    failwith "Unexpected end of token stream"
  else
    match peek tkns with
    | Tint n  -> (EInt n, advance tkns)
    | Tbool n -> (EBool n, advance tkns)
    | Tlparen -> begin
      let tkns       = consume Tlparen tkns in
      let tok        = peek tkns in
      let tkns       = consume tok tkns in
      let (e1, tkns) = parse tkns in
      let (e2, tkns) = parse tkns in
      if tok = Tif then
        let (e3, tkns)= parse tkns in
      let tkns       = consume Trparen tkns in
      match tok with
      | Tplus -> (EAdd (e1, e2), tkns)
      | Tmin  -> (EMin (e1, e2), tkns)
      | Tdiv  -> (EDiv (e1, e2), tkns)
      | Tmult -> (EMult (e1, e2), tkns)
      | Tloq  -> (ELoq (e1, e2), tkns)
      | Tif   -> (Tif (e1, e2, e3), tkns)
    end
    | t       -> failwith (Printf.sprintf "Unexpected token found : %s" (string_of_token t))
