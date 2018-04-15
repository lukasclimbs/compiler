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
%token IF THEN ELSE

%token EOF

%left IF THEN ELSE LOQ
%left PLUS MINUS
%left MULT DIV


%start <Lang.exp> prog

%%

prog:
  | e=exp EOF                           { e }

exp:
  | n=INT                                 { EInt n }
  | n=BOOL                                { EBool n}
  | e1=exp PLUS e2=exp                    { EAdd (e1, e2) }
  | e1=exp MINUS e2=exp                   { EMin (e1, e2)}
  | e1=exp MULT e2=exp                    { EMult (e1, e2)}
  | e1=exp DIV e2=exp                     { EDiv (e1, e2)}
  | e1=exp LOQ e2=exp                     { ELoq (e1, e2)}
  | IF e1=exp THEN e2=exp ELSE e3=exp     { EIf (e1, e2, e3)}
  | LPAREN e1=exp PLUS e2=exp RPAREN      { EAdd (e1, e2) }
  | LPAREN e1=exp MINUS e2=exp RPAREN     { EMin (e1, e2)}
  | LPAREN e1=exp MULT e2=exp RPAREN      { EMult (e1, e2)}
  | LPAREN e1=exp DIV e2=exp RPAREN       { EDiv (e1, e2)}
  | LPAREN e1=exp LOQ e2=exp RPAREN       { ELoq (e1, e2)}
  | LPAREN IF e1=exp THEN e2=exp ELSE e3=exp RPAREN  { EIf (e1, e2, e3)}