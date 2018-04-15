{
open Lexing
open Parser

exception Lexer_error of string

let string_of_token (t:token) : string =
  match t with
  | INT n  -> string_of_int n
  | BOOL n -> string_of_bool n
  | LPAREN -> "("
  | RPAREN -> ")"
  | PLUS   -> "+"
  | MINUS  -> "-"
  | MULT   -> "*"
  | DIV    -> "/"
  | LOQ    -> "<="
  | IF     -> "if"
  | EOF    -> "EOF"

let string_of_token_list (tkns : token list) : string =
  "[" ^ (String.concat "," (List.map string_of_token tkns)) ^ "]"

let symbols : (string * Parser.token) list =
  [ ("(", LPAREN)
  ; (")", RPAREN)
  ; ("+", PLUS)
  ; ("-", MINUS)
  ; ("*", MULT)
  ; ("/", DIV)
  ]

let create_symbol lexbuf =
  let str = lexeme lexbuf in
  List.assoc str symbols

let create_int lexbuf = lexeme lexbuf |> int_of_string

let create_bool lexbuf = lexeme lexbuf |> bool_of_string
}

let newline    = '\n' | ('\r' '\n') | '\r'
let whitespace = ['\t' ' ']
let digit      = ['0'-'9']

rule token = parse
  | eof                               { EOF }
  | digit+                            { INT (create_int lexbuf) }
  | whitespace+ | newline+            { token lexbuf }
  | '(' | ')' | '+' | '-' | '*' | '/' { create_symbol lexbuf }
  | "<="                              { LOQ }
  | "true" | "false"                  { BOOL (create_bool lexbuf) }
  | "if"                              { IF }
  | _ as c { raise @@ Lexer_error ("Unexpected character: " ^ Char.escaped c) }