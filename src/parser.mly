%{
open Lang
%}

%token <int> INT
%token <bool> BOOL
%token <string> VAR

%token LPAREN     
%token RPAREN  
%token PLUS       
%token MINUS      
%token MULT       
%token DIV        
%token LOQ (* <= *)
%token IF 
%token THEN 
%token ELSE
%token LET 
%token IN 
%token EQUALS
%token FUN 
%token ARROW
%token TBOOL
%token TINT
%token RARROW
%token EOF
%token AND
%token NOT
%token NOR
%token OR
%token NAND
%token XOR
%token XNOR
(*%token WHILE*)
(*%token DO*)
(*%token REF
%token ASS
%token DER*)


%left RARROW
%left LET IN  EQUALS FUN ARROW (*REF ASS DER*)
%left IF THEN ELSE (*DO wWHILE*)
%left LOQ AND OR NOT XNOR XOR NAND NOR
%left MULT DIV
%left PLUS MINUS VAR




%start <Lang.exp> prog

%%

prog:
  | e=exp EOF                             { e }

exp:
  | FUN n=VAR TINT ARROW e=exp            { EFun (n, TInt, e) }
  | FUN n=VAR TBOOL ARROW e=exp           { EFun (n, TBool, e) }
  | i = INT                               { EInt i }
  | b = BOOL                              { EBool b }
  | v = VAR                               { EVar v }
  | LPAREN e=exp RPAREN                   { e }
  | e1=exp PLUS e2=exp                    { EAdd (e1, e2) }
  | e1=exp MINUS e2=exp                   { EMin (e1, e2) }
  | e1=exp MULT e2=exp                    { EMult (e1, e2) }
  | e1=exp DIV e2=exp                     { EDiv (e1, e2) }
  | e1=exp LOQ e2=exp                     { ELoq (e1, e2) }
  | e1=exp AND e2=exp                     { EAnd (e1, e2) }
  | NOT e=exp                             { ENot e }
  | e1=exp OR e2=exp                      { EOr (e1, e2) }
  | e1=exp NOR e2=exp                     { ENor (e1, e2) }
  | e1=exp XNOR e2=exp                    { EXnor (e1, e2) }
  | e1=exp XOR e2=exp                     { EXor (e1, e2) }
  | e1=exp NAND e2=exp                    { ENand (e1, e2) }
  | IF e1=exp THEN e2=exp ELSE e3=exp     { EIf (e1, e2, e3) }
  | LET e1=VAR EQUALS e2=exp IN e3=exp    { ELet (e1, e2, e3) }
  | v=exp RARROW e=exp                    { ECall (v, e) }
  

(*expB:
 | FUN n=exp ARROW e=exp     {EFun (n, e)}
 | i = INT                   {EInt i}
 | b = BOOL                  {EBool b}
 | LPAREN e=exp RPAREN       { e }

label:
 | v = VAR                   {EVar v}*)

