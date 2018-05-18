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

%token EOF

%left IF THEN ELSE
%left LET IN FUN ARROW
%left MULT DIV
%left PLUS MINUS




%start <Lang.exp> prog

%%

prog:
  | e=exp EOF                             { e }

exp:
  | FUN n=VAR ARROW e=exp                 {EFun (n, e)}
  | i = INT                               {EInt i}
  | b = BOOL                              {EBool b}
  | v = VAR                               { EVar v }
  | LPAREN e=exp RPAREN                   { e }
  | e1=exp PLUS e2=exp                    { EAdd (e1, e2) }
  | e1=exp MINUS e2=exp                   { EMin (e1, e2)}
  | e1=exp MULT e2=exp                    { EMult (e1, e2)}
  | e1=exp DIV e2=exp                     { EDiv (e1, e2)}
  | e1=exp LOQ e2=exp                     { ELoq (e1, e2)}
  | IF e1=exp THEN e2=exp ELSE e3=exp     { EIf (e1, e2, e3)}
  | LET e1=exp EQUALS e2=exp IN e3=exp    { ELet (e1, e2, e3)}
  | v=exp e=exp                           { ECall (v, e)}

(*expB:
 | FUN n=exp ARROW e=exp     {EFun (n, e)}
 | i = INT                   {EInt i}
 | b = BOOL                  {EBool b}
 | LPAREN e=exp RPAREN       { e }

label:
 | v = VAR                   {EVar v}*)

