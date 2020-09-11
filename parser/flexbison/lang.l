%{
	//  -----  Source  -----  //

	#include <iostream>
	#include <string>
	#include <cstring>
	#include <initializer_list>
	#include <memory>

	#define DEBUG_FLEX 1

	// Convenient facilities for debug output
	#if DEBUG_FLEX == 1
	template <typename ...Args>
	void print_debug(const Args&... args)
	{
		(void)std::initializer_list<int>{
		    ((void)(std::cout << args), 0)...
		};
	}
	# define make_token(...)
	#else  // #if DEBUG_FLEX == 1
	# include <parser.hh>
	# define print_debug(...)
	# define make_token(_TOKEN_NAME_, ...) yy::parser::make_##_TOKEN_NAME_(__VA_ARGS__)
	#endif  // #if DEBUG_FLEX == 1

	#define token(_TOKEN_NAME_, ...) print_debug(#_TOKEN_NAME_); make_token(_TOKEN_NAME_, __VA_ARGS__)

	using namespace std;
	extern int yylex();
	size_t linenum=1;
%}

%option noyywrap
%option reentrant
/*%option bison-bridge*/
%option noinput
%option nounput

NO_QUO1    [^']{-}[\\]|(\\\')|(\\\\)
NO_QUO2    [^"]{-}[\\]|(\\\")|(\\\\)
NO_QUOB    [^`]{-}[\\]|(\\\`)|(\\\\)
QUO1       \'
QUO2       \"
QUOB       \`
ASTERISK   \*
REGEX_TYPE [rg]?
ENDLS      \n

%%

#.*\n             linenum++; print_debug("line: ", linenum);
\n                linenum++; print_debug("line: ", linenum);
^\s+/[^[:space:]] token(INDENT, noscratch::indent::type::space, std::strlen(yytext));
^\t+/[^[:space:]] token(INDENT, noscratch::indent::type::tab, std::strlen(yytext));
fragment          token(FRAGMENT);
follow            token(FOLLOW);
transform         token(TRANSFORM);
out               token(OUT);
\!.*              token(CUSTOM_COMMAND);
filter            token(FILTER);
{ASTERISK}        token(REGEX, noscratch::text::type::glob, "*");
[[:space:]]       ;

{REGEX_TYPE}{QUO1}{NO_QUO1}*{QUO1} token(REGEX, noscratch::text::detect_type(yytext), yytext);
{REGEX_TYPE}{QUO2}{NO_QUO2}*{QUO2} token(REGEX, noscratch::text::detect_type(yytext), yytext);
{REGEX_TYPE}{QUOB}{NO_QUOB}*{QUOB} token(REGEX, noscratch::text::detect_type(yytext), yytext);

%%

#if DEBUG_FLEX == 1
int main()
{
	yyscan_t scanner;
	yylex_init(&scanner);
	yylex(scanner);
	yylex_destroy(scanner);
	return 0;
}
#endif  // DEBUG_FLEX == 1