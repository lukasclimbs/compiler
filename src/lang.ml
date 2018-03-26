type exp =
  | EInt of int
  | EBool of bool
  | EAdd of exp * exp
  | EMult of exp * exp
  | EDiv of exp * exp
  | EMin of exp * exp
  | ELoq of exp * exp (* less than or equal to*)
  | EIf of exp * exp * exp

let rec interpret_bool (e:exp) : bool =
  match e with
  | EBool n          -> n
  | ELoq (e1, e2)    -> interpret e1 <= interpret e2
  | _                ->
    failwith "Error: An unknown value appeared where a bool should be."
and

  interpret (e:exp) : exp =
  match e with
  | EInt n           -> EInt n
  | EAdd (e1, e2)    -> match (interpret e1, interpret e2) with
                        | (EInt a1, EInt a2) -> EInt (a1 + a2)
                        | _ -> failwith "Likely type mismatch"
  (*| EMult (e1, e2)   -> match (interpret e1, interpret e2) with
                        | (EInt a1, EInt a2) -> EInt (a1 * a2)
                        | _ -> failwith "likely type mismatch"*)
  | EDiv (e1, e2)    ->
      if (interpret e2 == 0) then  (*catches division by 0*)
        failwith "Division by 0 is not supported."
      else interpret e1 / interpret e2
  | EMin (e1, e2)    -> interpret e1 - interpret e2
  | EIf (e1, e2, e3) ->
      if interpret_bool e1 then
        interpret e2
      else interpret e3
  | _                -> failwith "Unknown expression encountered."
