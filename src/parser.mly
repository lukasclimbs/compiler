%{
open Lang
%}

%token <int> INT
%token <bool> BOOL

%token LPAREN     
%token RPAREN     
%token PLUS       
%token MINUS      
%token MULT       
%token DIV        
%token LOQ (* <= *)
%token IF

%token EOF


%start <Lang.exp> prog

%%

prog:
  | e=exp EOF                           { e }

exp:
  | n=INT                                 { EInt n }
  | n=BOOL                                { EBool n}
  | LPAREN PLUS e1=exp e2=exp RPAREN      { EAdd (e1, e2) }
  | LPAREN MINUS e1=exp e2=exp RPAREN     { EMin (e1, e2)}
  | LPAREN MULT e1=exp e2=exp RPAREN      { EMult (e1, e2)}
  | LPAREN DIV e1=exp e2=exp RPAREN       { EDiv (e1, e2)}
  | LPAREN LOQ e1=exp e2=exp RPAREN       { ELoq (e1, e2)}
  | LPAREN IF e1=exp e2=exp e3=exp RPAREN { EIf (e1, e2, e3)}