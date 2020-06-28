%{
  #include <cstdio>
  #include <iostream>
  using namespace std;

  // Declare stuff from Flex that Bison needs to know about:
  extern int yylex();
  extern int yyparse();
  extern FILE *yyin;

  void yyerror(const char *s);
%}

// Bison fundamentally works by asking flex to get the next token, which it
// returns as an object of type "yystype".  Initially (by default), yystype
// is merely a typedef of "int", but for non-trivial projects, tokens could
// be of any arbitrary data type.  So, to deal with that, the idea is to
// override yystype's default typedef to be a C union instead.  Unions can
// hold all of the types of tokens that Flex could return, and this this means
// we can return ints or floats or strings cleanly.  Bison implements this
// mechanism with the %union directive:
%union {
  int ival;
  float fval;
  char *sval;
}

// Define the "terminal symbol" token types I'm going to use (in CAPS
// by convention), and associate each with a field of the %union:
%token <ival> INT
%token <fval> FLOAT
%token <sval> STRING

%token SNAZZLE
%token TYPE
%token END
%token ENDL

%%
// This is the actual grammar that bison will parse, but for right now it's just
// something silly to echo to the screen what bison gets from flex.  We'll
// make a real one shortly:
snazzle:
   snazzle INT {
      /* Man, don't do RR-grammar because it may cause
       * internal stack overflow, when you have a big input */
      cout << "bison found an int: " << $2 << endl;
      cout << "this thing is evaluated before \'(\' INT is evaluated" << endl;
      cout << "So if something requires an immediate action, use this trick! " << endl;
    }
    ')' INT
  | snazzle FLOAT   {
      cout << "bison found a float: " << $2 << endl;
    }
  | snazzle STRING {
      cout << "bison found a string: " << $2 << endl; free($2);
    }
  | INT            {
      cout << "bison found an int: " << $1 << endl;
    }
  | FLOAT          {
      cout << "bison found a float: " << $1 << endl;
    }
  | STRING         {
      cout << "bison found a string: " << $1 << endl; free($1);
    }
  ;
%%

int main(int argc, char** argv) {
	if (argc != 2) {
		return -1;
	}
//  	FILE *myfile = fopen("a.snazzle.file", "r");
  	FILE *myfile = fopen(argv[1], "r");
	if (!myfile) {
		cout << "I can't open a.snazzle.file!" << endl;
		return -1;
	}
	yyin = myfile;

	yyparse();

}

void yyerror(const char *s) {
  cout << "EEK, parse error!  Message: " << s << endl;
  // might as well halt now:
  exit(-1);
}
