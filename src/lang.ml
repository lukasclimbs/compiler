type exp =
  | EInt of int
  | EBool of bool
  | EAdd of exp * exp
  | EMult of exp * exp
  | EDiv of exp * exp
  | EMin of exp * exp
  | ELoq of exp * exp (* less than or equal to*)
  | EIf of exp * exp * exp


let rec string_of_exp (e: exp) : string =
  match e with
  | EInt n           -> string_of_int n
  | EBool n          -> string_of_bool n
  | EAdd (e1, e2)    -> "(+ " ^ string_of_exp e1 ^ " " ^ string_of_exp e2 ^ ")"
  | EMult (e1, e2)   -> "(* " ^ string_of_exp e1 ^ " " ^ string_of_exp e2 ^ ")"
  | EDiv (e1, e2)    -> "(/ " ^ string_of_exp e1 ^ " " ^ string_of_exp e2 ^ ")"
  | EMin (e1, e2)    -> "(- " ^ string_of_exp e1 ^ " " ^ string_of_exp e2 ^ ")"
  | ELoq (e1, e2)    -> "(<= " ^ string_of_exp e1 ^ " " ^ string_of_exp e2 ^ ")"
  | EIf (e1, e2, e3) -> "(if " ^ string_of_exp e1 ^ " " ^ string_of_exp e2 ^ " "
      ^ string_of_exp e3 ^ ")"


let rec interpret (e:exp) : exp =
  match e with
  | EInt n           -> EInt n
  | EBool n          -> EBool n
  | EAdd (e1, e2)    -> (match (interpret e1, interpret e2) with
                        | (EInt a1, EInt a2) -> EInt (a1 + a2)
                        | _ -> failwith "Likely type mismatch")
  | EMult (e1, e2)   -> (match (interpret e1, interpret e2) with
                        | (EInt a1, EInt a2) -> EInt (a1 * a2)
                        | _ -> failwith "likely type mismatch")
  | EDiv (e1, e2)    -> (match (interpret e1, interpret e2) with
                              | (EInt a1, EInt a2) ->
                                if a2 = 0 then failwith "division by 0"
                                else  EInt (a1 / a2)
                              | _ -> failwith "likely type mismatch")
  | EMin (e1, e2)    -> (match (interpret e1, interpret e2) with
                        | (EInt a1, EInt a2) -> EInt (a1 - a2)
                        | _ -> failwith "likely type mismatch")
  | EIf (e1, e2, e3) -> (match interpret e1 with
                        | EBool b -> if b then interpret e2 else interpret e3
                        | _ -> failwith "likely type mismatch")
  | ELoq (e1, e2)    -> (match (interpret e1, interpret e2) with
                        | (EInt a1, EInt a2) -> EBool (a1 <= a2)
                        | _ -> failwith "likely type mismatch")
