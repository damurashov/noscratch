%{
  #include <iostream>
  //#include "lang.tab.h"

  using namespace std;
  extern int yylex();
  int linenum=1;
%}

%option noyywrap 

NO_QUO1 [^']|(\\\')|(\\)
NO_QUO2 [^"]|(\\\")|(\\)
NO_QUOB [^`]|(\\\`)|(\\)
QUO1 \'
QUO2 \"
QUOB \`
ASTERISK \*
ENDLS \n+
REGEX_TYPE [rg]?

%%

\n                { ++linenum; }
\#.*$             {std::cout << linenum <<" " << " GOT: comment\n"; }

{REGEX_TYPE}{QUO1}{NO_QUO1}*{QUO1} { std::cout << linenum << " GOT: regex\n"; /* Remove esc. quotes, Return REGEX */ }
{REGEX_TYPE}{QUO2}{NO_QUO2}*{QUO2} { std::cout << linenum << " GOT: regex\n"; /* Remove esc. quotes, Return REGEX */ }
{REGEX_TYPE}{QUOB}{NO_QUOB}*{QUOB} { std::cout << linenum << " GOT: regex\n"; /* Remove esc. quotes, Return REGEX */ }

^\t* { /* Indentation */ }
[ \t]                         ; /* Ignore spaces, tabs */

fragment         {std::cout << linenum << " " << " GOT: fragment\n";}
follow           {std::cout << linenum << " " << " GOT: follow\n";}
transform        {std::cout << linenum << " " << " GOT: transform\n";}
out              {std::cout << linenum << " " << " GOT: out\n";}
[:space:]*\!.*   {std::cout << linenum << " " << " GOT: custom command\n";}
filter           {std::cout << linenum << " " << " GOT: filter\n";}
{ASTERISK}       {std::cout << linenum << " " << " GOT: asterisk\n";}


%%

int main(int, char** argv) {

	FILE *myfile = fopen(argv[1], "r");
	if (!myfile) {
		cout << "I can't open a.snazzle.file!" << endl;
		return -1;
	}
	yyin = myfile;

	while(yylex());
}
