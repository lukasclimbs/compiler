type token =
  | Tint of int
  | Tbool of bool
  | Tlparen
  | Trparen
  | Tplus
  | Tmin
  | Tdiv
  | Tmult
  | Tif
  | Tloq

let string_of_token (t:token) : string =
  match t with
  | Tint n  -> string_of_int n
  | Tbool n -> string_of_bool n
  | Tlparen -> "("
  | Trparen -> ")"
  | Tplus   -> "+"
  | Tmin    -> "-"
  | Tdiv    -> "/"
  | Tmult   -> "*"
  | Tif     -> "if"
  | Tloq    -> "<="

let string_of_token_list (tkns: token list) : string =
  String.concat "," (List.map string_of_token tkns)

let peek (src:char Stream.t) : char =
  match Stream.peek src with
  | Some ch -> ch
  | None -> failwith "Unexpected end of file encountered"

let advance : char Stream.t -> char = Stream.next

let rec advanced (n : int) src =
  if n = 0 then
    ()
  else
    begin
      advance src |> ignore;
      advanced (n - 1) src
    end

let is_empty (src:char Stream.t) : bool =
  try
    Stream.empty src; true
  with
    Stream.Failure -> false

let is_whitespace (ch:char) : bool =
  ch = ' ' || ch = '\012' || ch = '\n' || ch = '\r' || ch = '\t'

let is_digit (ch:char) : bool =
  let code = Char.code ch in
    48 <= code && code <= 57

let is_alpha (ch:char) : bool =
  let code = Char.code ch in
    97 <= code && code <= 122

let next_string (src: char Stream.t) (str: String.t) : bool =
  let spaces = String.length str in
    let newstring = String.concat "" (List.map Char.escaped (Stream.npeek spaces src)) in
    advanced spaces src;
    newstring = str

let is_bool_string (st: string) : bool =
  "true" = st || st = "false"

let rec string_of_tokens (tkns : token list) : string =
    match tkns with
    | (Tint n)::tkns'   -> string_of_int n ^ "," ^ string_of_token_list tkns'
    | (Tbool n)::tkns' -> string_of_bool n ^ "," ^ string_of_token_list tkns'
    | (Tlparen)::tkns' -> "(," ^ string_of_tokens tkns'
    | (Trparen)::tkns' -> ")," ^ string_of_tokens tkns'
    | (Tplus)::tkns'   -> "+," ^ string_of_tokens tkns'
    | (Tmin)::tkns'    -> "-," ^ string_of_tokens tkns'
    | (Tdiv)::tkns'    -> "/," ^ string_of_tokens tkns'
    | (Tmult)::tkns'   -> "*," ^ string_of_tokens tkns'
    | (Tif)::tkns'     -> "if," ^ string_of_tokens tkns'
    | (Tloq)::tkns'    -> "<=," ^ string_of_tokens tkns'
    | _                -> ""

let string_of_token_list (tkns : token list) : string =
  "[" ^ (string_of_tokens tkns) ^ "]"


let lex (src:char Stream.t) : token list =
  let rec lex_dig acc =
    if is_digit (peek src) then
      lex_dig (acc ^ (Char.escaped (advance src)))
    else
      int_of_string acc
 in
  let rec go () =
    if not (is_empty src) then
      let ch = peek src in
      match ch with
      | '(' -> advance src |> ignore; Tlparen :: go()
      | ')' -> advance src |> ignore; Trparen :: go()
      | '+' -> advance src |> ignore; Tplus :: go()
      | '/' -> advance src |> ignore; Tdiv :: go()
      | '-' -> advance src |> ignore; Tmin :: go()
      | '*' -> advance src |> ignore; Tmult :: go()
      | _   ->
        if is_whitespace ch then
          begin advance src |> ignore; go () end

        else if is_digit ch then
          let n = lex_dig "" in
          Tint n :: go ()

        else if ch = 'i' then
          if next_string src "if" then
            Tif :: go ()
          else failwith (Printf.sprintf "Unexpected expression beginning with: %c" ch)

        else if ch = '<' then
          if next_string src "<=" then
            Tloq :: go ()
          else failwith (Printf.sprintf "Unexpected expression beginning with: %c" ch)

        else if ch = 't' then
          if next_string src "true" then
            Tbool true :: go ()
          else failwith (Printf.sprintf "Unexpected expression beginning with: %c" ch)

        else if ch = 'f' then
          if next_string src "false" then
            Tbool false :: go ()
          else  failwith (Printf.sprintf "Unexpected expression beginning with: %c" ch)

        else
          failwith (Printf.sprintf "Unexpected character found: %c" ch)
    else
      []
  in
    go ()
