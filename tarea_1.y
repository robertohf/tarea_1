%require "3.2"

%code requires{
   #include "ast.h"

   extern StmtPtr root;
}

%{
   #include <cstdio>
   #include <stdio.h>
   #include <list>
   #include "ast.h"
   int yylex();
   extern int yyparse();
   extern int yylineno;

   void yyerror(const char * s);
%}

%union {
  int int_t;
  char *string_t;

  StmtList *stmtList_t;
  StmtPtr stmt_t;
  ExprPtr expr_t;
};

/*
BlockP: %empty { }
      | ';' Stmt BlockP { $$ = new StmtList; $$->push_back($2); }
;

Expr: Term ExprP { $$ = $1; }
;

ExprP: %empty { }
      | '+' Term ExprP { $$ = new AddExpr($2, $3); }
      | '-' Term ExprP { $$ = new SubExpr($2, $3); }
;

Term: Factor TermP { $$ = $1; }
;

TermP: %empty { }
      |  '*' Factor TermP { $$ = new MultExpr($2, $3); }
      |  '/' Factor TermP { $$ = new DivExpr($2, $3); }
;
*/

%token KW_WRITE KW_INT KW_DEF KW_END
%token<int_t> TK_INT
%token<string_t> TK_IDENT

%type<stmtList_t> Block
%type<stmt_t> Program Stmt Write AssignDecl
%type<expr_t> Expr Term Factor

%start Program

%%
Program: Block { root = new BlockStmt($1); root->isTrue = true; }
;

Block: Block Stmt ';' { $$ = $1; $$->push_back($2); }
      | Stmt ';' { $$ = new StmtList(); $$->push_back($1); }
;

Stmt: Write { $$ = $1; }
      | AssignDecl { $$ = $1; }
;

Write: KW_WRITE Expr { $$ = new WriteStmt($2); }
;

AssignDecl: TK_IDENT '=' Expr { $$ = new AssignStmt($1, $3); }
;

Expr: Expr '+' Term { $$ = new AddExpr($1, $3); }
      | Expr '-' Term { $$ = new SubExpr($1, $3); }
      | Term { $$ = $1; }
;


Term: Term '*' Factor { $$ = new MultExpr($1, $3); }
      | Term '/' Factor { $$ = new DivExpr($1, $3); }
      | Factor { $$ = $1; }
;

Factor: TK_INT { $$ = new IntExpr($1); }
      | TK_IDENT { $$ = new IdentExpr($1); }
      | '(' Expr ')' { $$ = $2; }
;
%%

void yyerror(const char * s){
      fprintf(stderr, "Line %d, error: %s\n", yylineno, s);
}