%{
  #include <iostream>
  using namespace std;
  extern int yylex();
  int linenum=0;
%}

/* That's how we prevent flex from looking for yywrap function*/
%option noyywrap 

%%
[ \t]                         ; /* Ignore spaces, tabs */
\n                            { ++linenum; }
\".*\"                        { /* We've got string */ }
[a-zA-Z_]+[a-zA-Z0-9_]*\".*\" { /* We've got regex */ }   
%%
int main(int, char**) {
  // lex through the input:
  while (yylex());
}
