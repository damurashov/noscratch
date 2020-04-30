%{
  #include <iostream>
  #include "lang.tab.h"

  using namespace std;
  extern int yylex();
  int linenum=0;
%}

/* That's how we prevent flex from looking for yywrap function*/
%option noyywrap 

%%
[ \t]                         ; /* Ignore spaces, tabs */
\n                            { ++linenum; }
\".*\"                        { yylval.regex = strdup(yytext); return STRING;  }
[a-zA-Z_]+[a-zA-Z0-9_]*\".*\" { yylval.string = strdup(yytext); return REGEX;  }   
%%
int main(int, char**) {
  // lex through the input  
  FILE *myfile = fopen("a.snazzle.file", "r");
  // make sure it's valid:
  if (!myfile) {
    cout << "I can't open a.snazzle.file!" << endl;
    return -1;
  }
  // set lex to read from it instead of defaulting to STDIN:
  yyin = myfile;
  while (yylex());
}
