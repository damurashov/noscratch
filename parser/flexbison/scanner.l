%{
	//  -----  Source  -----  //

	#include <iostream>
	#include <string>
	#include <cstring>
	#include <initializer_list>
	#include <memory>
	#include "Scanner.hpp"
	#include "Interpreter.hpp"
	#include "location.hh"
	#include "Types.hpp"

	using namespace Nosc;
	
	#define DEBUG_FLEX 1

	//  -----  Debug facilities  -----  //

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
	# include "lang.tab.hh"
	# define print_debug(...)
	# define make_token(_TOKEN_NAME_, ...) Nosc::Parser::make_##_TOKEN_NAME_(__VA_ARGS__)
	#endif  // #if DEBUG_FLEX == 1

	//  -----  From example  -----  //

	#define token(_TOKEN_NAME_, ...)              \
		print_debug(#_TOKEN_NAME_);               \
		make_token(_TOKEN_NAME_, __VA_ARGS__ )

	// Original yyterminate() macro returns int. Since we're using Bison 3 variants
	// as tokens, we must redefine it to change type from `int` to `Parser::semantic_type`
	#define yyterminate() Nosc::Parser::make_END(Nosc::location());

	// This will track current scanner location.
	// Action is called when length of the token is known.
	//#define YY_USER_ACTION m_driver.increaseLocation(yyleng);
	
	// !!!WARNING!!!
	// Location API is used, but the location is not initialized, 'cause I'm lazy. When making
	// a token with make_{something} method you can pass detailed token location. Current location
	// is accessible with m_driver.location() method. All puzzle elements are there - just
	// pass location value in every action code block below. I'm going to waste more time writing
	// this excuse than putting this boilerplate below...
	//
	// Location class can be found in location.hh and posistion.hh files. It's just a bit too much
	// boilerplate for this small example. Bummer.
%}

%option nodefault
%option noyywrap
%option c++
%option yyclass="Scanner"
%option prefix=""

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

#.*\n                  linenum++; print_debug("comment, line: ", linenum);
\n                     linenum++; print_debug("line: ", linenum);
^\s+/[^[:space:]\n\r]  token(INDENT, {Nosc::Indent::Type::space, std::strlen(yytext)});
^\t+/[^[:space:]\n\r]  token(INDENT, {Nosc::Indent::Type::space, std::strlen(yytext)});
fragment               token(FRAGMENT);
follow                 token(FOLLOW);
transform              token(TRANSFORM);
out                    token(OUT);
\!.*                   token(CUSTOM_COMMAND);
filter                 token(FILTER);
{ASTERISK}             token(REGEX, {Nosc::Text::Type::glob, "*"});
[[:space:]]            ;
<<EOF>>                { return yyterminate(); }

{REGEX_TYPE}{QUO1}{NO_QUO1}*{QUO1} token(REGEX, {Nosc::Text::detect_type(yytext), yytext});
{REGEX_TYPE}{QUO2}{NO_QUO2}*{QUO2} token(REGEX, {Nosc::Text::detect_type(yytext), yytext});
{REGEX_TYPE}{QUOB}{NO_QUOB}*{QUOB} token(REGEX, {Nosc::Text::detect_type(yytext), yytext});

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