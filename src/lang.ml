 type typ =
 | TInt 
 | TBool
 | TAlt of typ * typ
 | TRef of typ
 | TUnit

type exp =
  | EInt of int
  | EBool of bool
  | EAdd of exp * exp
  | EMult of exp * exp
  | EDiv of exp * exp
  | EMin of exp * exp
  | ELoq of exp * exp (* less than or equal to*)
  | EIf of exp * exp * exp
  | ELet of string * exp * exp
  | EFun of string * typ * exp
  | ECall of exp * exp
  | EVar of string
  | EAnd of exp * exp
  | EOr  of exp * exp
  | ENor of exp * exp
  | EXnor of exp * exp
  | EXor  of exp * exp
  | ENot  of exp
  | ENand of exp * exp
  | ERef of exp
  | EAss of exp * exp
  | EDer of exp
  | EWhi of exp * exp * exp

type value =
 | VInt of int
 | VBool of bool
 | VFun of string * exp
 | VPtr of int
 | VUnit

let rec string_of_typ (t:typ) : string =
  match t with
  | TInt         -> "int"
  | TBool        -> "bool"
  | TAlt (t1,t2) -> string_of_typ t1 ^ " -> " ^ string_of_typ t2
  | TRef t       -> "[" ^ string_of_int t ^ "]"
  | TUnit t      -> "unit"

let rec string_of_exp (e: exp) : string =
  match e with
  | EInt n           -> "(" ^ string_of_int n ^ ")"
  | EBool n          -> "(" ^ string_of_bool n ^ ")"
  | EVar s           -> s
  | ERef n           -> "(ref " ^ string_of_int n ^ ")"
  | EDer n           -> "(! " ^ string_of_exp n ^ ")"
  | EAss n           -> "(Assign " ^ string_of_exp n ^ ")"
  | EAdd (e1, e2)    -> "(" ^ string_of_exp e1 ^ " + " ^ string_of_exp e2 ^ ")"
  | EMult (e1, e2)   -> "(" ^ string_of_exp e1 ^ " * " ^ string_of_exp e2 ^ ")"
  | EDiv (e1, e2)    -> "(" ^ string_of_exp e1 ^ " / " ^ string_of_exp e2 ^ ")"
  | EMin (e1, e2)    -> "(" ^ string_of_exp e1 ^ " - " ^ string_of_exp e2 ^ ")"
  | ELoq (e1, e2)    -> "(" ^ string_of_exp e1 ^ " <= " ^ string_of_exp e2 ^ ")"
  | EIf (e1, e2, e3) -> "(if " ^ string_of_exp e1 ^ " " ^ string_of_exp e2 ^ " "
      ^ string_of_exp e3 ^ ")"
  | ELet (e1, e2, e3)-> "(let " ^ e1 ^ " = " ^ string_of_exp e2 ^ " in " ^ string_of_exp e3 ^ ")"
  | EFun (e1, t, e2) -> "(fun " ^ e1 ^" "^ string_of_typ t ^" -> " ^ string_of_exp e2 ^ ")"
  | ECall (e1, e2)   -> "(" ^ string_of_exp e1 ^ " " ^ string_of_exp e2 ^ ")"
  | EAnd (e1, e2)    -> "(" ^ string_of_exp e1 ^ " and " ^ string_of_exp e2 ^ ")"
  | EOr  (e1, e2)    -> "(" ^ string_of_exp e1 ^ " or " ^ string_of_exp e2 ^ ")"
  | ENor (e1, e2)    -> "(" ^ string_of_exp e1 ^ " nor " ^ string_of_exp e2 ^ ")"
  | EXnor (e1, e2)   -> "(" ^ string_of_exp e1 ^ " xnor " ^ string_of_exp e2 ^ ")"
  | EXor  (e1, e2)   -> "(" ^ string_of_exp e1 ^ " xor " ^ string_of_exp e2 ^ ")"
  | ENot s           -> "(Not" ^ string_of_exp s ^ ")"
  | ENand (e1, e2)  -> "(" ^ string_of_exp e1 ^ " xnand " ^ string_of_exp e2 ^ ")"
  | EWhi (e1, e2, e3) -> "While " ^ string_of_exp e1 ^ " do " ^ string_of_exp e2 ^ ")"


let rec string_of_val (v:value) : string =
  match v with
  | VInt n  -> string_of_int n
  | VBool b -> string_of_bool b
  | VFun (e1, e2) -> "(fun " ^ e1 ^ " -> " ^ string_of_exp e2 ^ ")"
  | VPtr n  -> "Reference: " ^ string_of_int n

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
  | ELet(e1, e2, e3) -> ELet(e1, (subst str v e2), (subst str v e3))
  | EFun(e1, t, e2)  -> EFun(e1, t, (subst str v e2))
  | ECall(e1, e2)    -> ECall(e1, (subst str v e2))
  | EAnd (e1, e2)    -> EAnd((subst str v e1), (subst str v e2))
  | EOr  (e1, e2)    -> EOr((subst str v e1), (subst str v e2))
  | ENor (e1, e2)    -> ENor((subst str v e1), (subst str v e2))
  | EXnor (e1, e2)   -> EXnor((subst str v e1), (subst str v e2))
  | EXor  (e1, e2)   -> EXor((subst str v e1), (subst str v e2))
  | ENot e1           -> ENot(subst str v e1)
  | ENand (e1, e2)  -> ENand((subst str v e1), (subst str v e2))
  | ERef n           -> ERef (subst str v n)
  | EAss n           -> Eass (subst str v n)
  | EDer n           -> EDer (subst str v n)
  | EWhi(e1, e2, e3) -> EWhi((subst str v e1) (subst str v e2) (subst str v e3))


let val_to_int (v:value) : int =
 match v with
 | VInt n -> n
 | v      -> failwith(Printf.sprintf "Unexpected val encountered: %s" (string_of_val v))

let val_to_bool (v:value) : bool =
 match v with
 | VBool n -> n
 | v       -> failwith(Printf.sprintf "Unexpected val encountered: %s" (string_of_val v))

type context = (string * typ) list

let lookup (c: context) (e:string) : typ =
  List.assoc e c

 let rec typecheck (c: context) (e:exp) : typ =
  match e with
  | EInt  n          -> TInt
  | EBool n          -> TBool
  | EVar  n          -> lookup c n
  | ERef  n          -> TRef(typecheck c n)
  | EDer  n          -> let t = typecheck c n in
                        match t with
                        | TRef m -> m
                        | _      -> failwith(Printf.sprintf "Dereferencing typecheck failed. Should match Ref, given %s" t)
  | EAss (e1, e2)    -> let t1 = typecheck c e1 in
                        let t2 = typecheck c e2 in
                        if t1 = t2 then t2 else 
                        failwith(Printf.sprintf "Cells must match what they're pointing to. Received types %s and %s" t1 t2)
  | EWhi (e1, e2, e3)-> begin 
                        typecheck c e2 |> ignore;
                        let t1 = typecheck c e1 in
                        match t1 with
                        | TBool -> TUnit
                        |_ -> failwith(Printf.sprintf "While loops must take a boolean, received %s" t1)
                         end
  | EAdd (e1, e2)    -> arith_check c e1 e2
  | EMin(e1, e2)    -> arith_check c e1 e2
  | EDiv (e1, e2)    -> arith_check c e1 e2
  | EMult(e1, e2)    -> arith_check c e1 e2
  | ELoq (e1, e2)    -> arith_check c e1 e2
  | EIf (e1, e2, e3) -> if_check c e1 e2 e3
  | ELet (s, e2, e3) -> let_check c s e2 e3
  | EFun (e1, t, e2) -> fun_check c e1 t e2
  | ECall (e1, e2)   -> call_check c e1 e2
  | EAnd (e1, e2)    -> bool_check c e1 e2
  | EOr  (e1, e2)    -> bool_check c e1 e2
  | ENor (e1, e2)    -> bool_check c e1 e2
  | EXnor (e1, e2)   -> bool_check c e1 e2
  | EXor  (e1, e2)   -> bool_check c e1 e2
  | ENot s           -> if (typecheck c s) = TBool then TBool else failwith(Printf.sprintf "expected type bool, was given %s" (string_of_exp s))
  | ENand (e1, e2)  -> bool_check c e1 e2

  and arith_check (c: context) (e1: exp) (e2: exp) : typ =
  let typ1 = typecheck c e1 in 
  let typ2 = typecheck c e2 in
    match typ1, typ2 with
    | (TInt, TInt) -> TInt
    |_             -> failwith(Printf.sprintf "expected type int, was given %s and %s" (string_of_exp e1) (string_of_exp e2))

  and bool_check (c: context) (e1: exp) (e2: exp) : typ =
  let typ1 = typecheck c e1 in 
  let typ2 = typecheck c e2 in
    match typ1, typ2 with
    | (TBool, TBool) -> TBool
    |_               -> failwith(Printf.sprintf "expected type bool, was given %s and %s" (string_of_exp e1) (string_of_exp e2))

  and if_check (c: context) (e1: exp) (e2: exp) (e3: exp) : typ =
  let typ1 = typecheck c e1 in 
  let typ2 = typecheck c e2 in
  let typ3 = typecheck c e3 in
    if typ1 = TBool 
    then
        if typ2 = typ3 
        then typ2 
        else (failwith (Printf.sprintf "%s and %s must have the same type" (string_of_exp e2)(string_of_exp e3))) 
    else failwith(Printf.sprintf "Expected type bool, given %s" (string_of_exp e1))

  and fun_check (c:context) (s: string) (t: typ) (e2: exp) : typ =
   let c = (s,t)::c in
   let t2 = (typecheck c e2) in
   TAlt(t, t2)

  and let_check (c: context) (s: string) (e2: exp) (e3: exp) : typ =
    let t1 = typecheck c e2 in
    let c = (s, t1) :: c in 
    let t2 = typecheck c e3 in
    if t1=t2 then t2 else failwith(Printf.sprintf "Typecheck error with let statements.")

  and call_check (c: context) (e1: exp) (e2: exp) : typ =
    let t1 = lookup c (string_of_exp e1) in 
    let t2 = typecheck c e2 in
    match t1 with
    | TAlt(ct1, ct2) -> (if ct1 = t2 then ct2 else (failwith (Printf.sprintf "Error: expected type %s. Given %s." (string_of_typ t1) (string_of_exp e2))))
    | _              -> (failwith (Printf.sprintf "%s. Does not have a proper function type." (string_of_typ t1)))
   
let nor (a:bool) (b:bool) : bool = 
  not (a || b)

let nand (a:bool) (b:bool) : bool = 
  not (a && b)

let xnor (a:bool) (b:bool) : bool =
  if a = b then true else false

let xor (a:bool) (b:bool) : bool =
  if (a = b) then false else true


let rec interpret (e:exp) : value =
  match e with
  | EInt  n          -> VInt n
  | EBool n          -> VBool n
  | ERef  n          -> if not(is_value n) 
                        then let n1 = interpret n in ERef(n1)
                        else 
  | EVar  n          -> failwith(Printf.sprintf "Unexpected variable encountered: %s" n)
  | EAdd (e1, e2)    -> VInt((val_to_int (interpret e1)) + (val_to_int (interpret e2)))
  | EMin (e1, e2)    -> VInt((val_to_int (interpret e1)) - (val_to_int (interpret e2)))
  | EMult (e1, e2)   -> VInt((val_to_int (interpret e1)) * (val_to_int (interpret e2)))
  | EDiv (e1, e2)    -> if val_to_int (interpret e2) = 0 then failwith "division by 0"
      else VInt((val_to_int (interpret e1)) / (val_to_int (interpret e2)))
  | EIf (e1, e2, e3) -> if val_to_bool (interpret e1) then interpret e2 else interpret e3
  | ELoq (e1, e2)    -> VBool((val_to_int (interpret e1)) <= (val_to_int (interpret e2)))
  | ELet (e1, e2, e3)-> interpret(subst e1 e2 e3)
  | EAnd (e1, e2)    -> VBool((val_to_bool (interpret e1)) && (val_to_bool (interpret e2)))
  | EOr  (e1, e2)    -> VBool((val_to_bool (interpret e1)) || (val_to_bool (interpret e2)))
  | ENor (e1, e2)    -> VBool(nor (val_to_bool (interpret e1)) (val_to_bool (interpret e2)))
  | EXnor (e1, e2)   -> VBool(xnor (val_to_bool (interpret e1)) (val_to_bool (interpret e2)))
  | EXor  (e1, e2)   -> VBool(xor (val_to_bool (interpret e1)) (val_to_bool (interpret e2)))
  | ENot e           -> VBool(not (val_to_bool (interpret e)))
  | ENand (e1, e2)   -> VBool(nand (val_to_bool (interpret e1)) (val_to_bool (interpret e2)))
  | EFun (x, t, e2)  -> VFun(x, e2)
  | ECall (e1, e2)   -> (match (interpret e1) with
                        |VFun (x, ef2) -> interpret (subst x e2 ef2)
                        |_             ->failwith(Printf.sprintf "Unexpected expression encountered: %s" (string_of_exp e1)))

