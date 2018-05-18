type exp =
  | EInt of int
  | EBool of bool
  | EAdd of exp * exp
  | EMult of exp * exp
  | EDiv of exp * exp
  | EMin of exp * exp
  | ELoq of exp * exp (* less than or equal to*)
  | EIf of exp * exp * exp
  | ELet of exp * exp * exp
  | EFun of string * exp
  | ECall of exp * exp
  | EVar of string


let rec string_of_exp (e: exp) : string =
  match e with
  | EInt n           -> "(" ^ string_of_int n ^ ")"
  | EBool n          -> "(" ^ string_of_bool n ^ ")"
  | EVar s           -> s
  | EAdd (e1, e2)    -> "(" ^ string_of_exp e1 ^ " + " ^ string_of_exp e2 ^ ")"
  | EMult (e1, e2)   -> "(" ^ string_of_exp e1 ^ " * " ^ string_of_exp e2 ^ ")"
  | EDiv (e1, e2)    -> "(" ^ string_of_exp e1 ^ " / " ^ string_of_exp e2 ^ ")"
  | EMin (e1, e2)    -> "(" ^ string_of_exp e1 ^ " - " ^ string_of_exp e2 ^ ")"
  | ELoq (e1, e2)    -> "(" ^ string_of_exp e1 ^ " <= " ^ string_of_exp e2 ^ ")"
  | EIf (e1, e2, e3) -> "(if " ^ string_of_exp e1 ^ " " ^ string_of_exp e2 ^ " "
      ^ string_of_exp e3 ^ ")"
  | ELet (e1, e2, e3)-> "(let " ^ string_of_exp e1 ^ " = " ^ string_of_exp e2 ^ " in " ^ string_of_exp e3 ^ ")"
  | EFun (e1, e2)    -> "(fun " ^ e1 ^ " -> " ^ string_of_exp e2 ^ ")"
  | ECall (e1, e2)   -> "(" ^ string_of_exp e1 ^ " " ^ string_of_exp e2 ^ ")"


let rec subst (str:string) (v:exp) (exp:exp) : exp =
  match exp with
  | EInt   n         -> exp
  | EBool  b         -> exp
  | EVar   s         -> if s = str then v else EVar s
  | EAdd  (e1, e2)   -> EAdd((subst str v e1), (subst str v e2))
  | EMin  (e1, e2)   -> EMin((subst str v e1), (subst str v e2))
  | EMult (e1, e2)   -> EMult((subst str v e1), (subst str v e2))
  | EDiv  (e1, e2)   -> EDiv((subst str v e1), (subst str v e2))
  | ELoq  (e1, e2)   -> ELoq((subst str v e1), (subst str v e2))
  | EIf (e1, e2, e3) -> EIf(((subst str v e1), (subst str v e2), (subst str v e3)))
  | ELet(e1, e2, e3) -> ELet((subst str v e1), (subst str v e2), (subst str v e3))
  | EFun(e1, e2)     -> EFun(e1, (subst str v e2))
  | ECall(e1, e2)    -> ECall((subst str v e1), (subst str v e2))

type value =
 | VInt of int
 | VBool of bool
 | VFun of string * exp

 let rec string_of_val (v:value) : string =
  match v with
  | VInt n  -> string_of_int n
  | VBool b -> string_of_bool b
  | VFun (e1, e2) -> "(fun " ^ e1 ^ " -> " ^ string_of_exp e2 ^ ")"

let val_to_int (v:value) : int =
 match v with
 | VInt n -> n
 | v      -> failwith(Printf.sprintf "Unexpected val encountered: %s" (string_of_val v))

let val_to_bool (v:value) : bool =
 match v with
 | VBool n -> n
 | v       -> failwith(Printf.sprintf "Unexpected val encountered: %s" (string_of_val v))

let rec interpret (e:exp) : value =
  match e with
  | EInt  n          -> VInt n
  | EBool n          -> VBool n
  | EVar  n          -> failwith(Printf.sprintf "Unexpected variable encountered: %s" n)
  | EAdd (e1, e2)    -> VInt((val_to_int (interpret e1)) + (val_to_int (interpret e2)))
  | EMin (e1, e2)    -> VInt((val_to_int (interpret e1)) - (val_to_int (interpret e2)))
  | EMult (e1, e2)   -> VInt((val_to_int (interpret e1)) * (val_to_int (interpret e2)))
  | EDiv (e1, e2)    -> if val_to_int (interpret e2) = 0 then failwith "division by 0"
      else VInt((val_to_int (interpret e1)) / (val_to_int (interpret e2)))
  | EIf (e1, e2, e3) -> if val_to_bool (interpret e1) then interpret e2 else interpret e3
  | ELoq (e1, e2)    -> VBool((val_to_int (interpret e1)) <= (val_to_int (interpret e2)))
  | ELet (e1, e2, e3)-> interpret(subst (string_of_exp e1) e2 e3)
  | EFun (x, e2)    -> VFun(x, e2)
  | ECall (e1, e2)   -> (match (interpret e1) with
                        |VFun (x, ef2) -> interpret (subst x e2 ef2)
                        |_             ->failwith(Printf.sprintf "Unexpected expression encountered: %s" (string_of_exp e1)))

