%option yylineno

%{
   #include "tokens.h"

   #define YY_DECL int yylex()

   FILE *fp;
%}

%x MultiLineComment

%%
"+" { return '+'; }
"-" { return '-'; }
"*" { return '*'; }
"/" { return '/'; }
"%" { return '%'; }
"=" { return '='; }
"(" { return '('; }
")" { return ')'; }
";" { return ';'; }
"int" { return KW_INT; }
"write" { return KW_WRITE; }
"def" { return KW_DEF; }
"end" { return KW_END; }
[a-zA-Z][_|0-9|a-zA-Z]* { yylval.string_t = strdup(yytext); return TK_IDENT; }
[0-9]+ { yylval.int_t = atoi(yytext); return TK_INT; }
[\t] { printf("\t"); }
[\r] { printf("\r"); }
[\n] { printf("\n"); }
[ ] { printf(" "); }
. { printf("\nInvalid Lexical Character %c, Line No. %d", yytext[0], yylineno); return YYUNDEF; }

"//"[^\n]* { }
"/*" { BEGIN(MultiLineComment); }
<MultiLineComment>"*/" { BEGIN(INITIAL); }
<MultiLineComment>.|\n {  }
<MultiLineComment><<EOF>> { printf("Block Comment not closed.\n"); yyterminate(); }
%%

int yywrap(void) {
   yylineno = 1;
   yyrestart(yyin);
   
   yyin = fp;
   if(yyin == NULL)
      return 0;
   return 1;
}