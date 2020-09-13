/* https://www.gnu.org/software/bison/manual/html_node/Calc_002b_002b-Parser.html */




%skeleton "lalr1.cc" /* -*- C++ -*- */
%require "3.0"
%defines
%define api.parser.class { Parser }

%define api.token.constructor
%define api.value.type variant
%define parse.assert
%define api.namespace { Nosc }
%code requires
{
	#include <iostream>
	#include <string>
	#include <vector>
	#include <stdint.h>

	using namespace std;

	namespace Nosc {
		class Scanner;
		class Interpreter;
	}
}

// Bison calls yylex() function that must be provided by us to suck tokens
// from the scanner. This block will be placed at the beginning of IMPLEMENTATION file (cpp).
// We define this function here (function! not method).
// This function is called only inside Bison, so we make it static to limit symbol visibility for the linker
// to avoid potential linking conflicts.
%code top
{
	#include <iostream>
	#include "scanner.h"
	#include "parser.hpp"
	#include "Interpreter.hpp"
	#include "location.hh"
	
	// yylex() arguments are defined in parser.y
	static Nosc::Parser::symbol_type yylex(Nosc::Scanner &scanner, Nosc::Interpreter &driver) {
		return scanner.get_next_token();
	}
	
	// you can accomplish the same thing by inlining the code using preprocessor
	// x and y are same as in above static function
	// #define yylex(x, y) scanner.get_next_token()
	
	using namespace Nosc;
}

%lex-param { Nosc::Scanner &scanner }
%lex-param { Nosc::Interpreter &driver }
%parse-param { Nosc::Scanner &scanner }
%parse-param { Nosc::Interpreter &driver }
%locations
%define parse.trace
%define parse.error verbose

%define api.token.prefix {TOKEN_}




%code{
	#include <string>
	#include "types.h"
%}

%token <Nosc::Text>  Regex
%token <Nosc::Indent> Indent

%token FRAGMENT
%token FOLLOW
%token TRANSFORM
%token OUT
%token FILTER
%token ENDLS
%token EMPTY_LINE
%token ASTERISK
%token CUSTOM_COMMAND

%start Fragment


%%

Fragment: FRAGMENT;

%%




// Bison expects us to provide implementation - otherwise linker complains
void Nosc::Parser::error(const location &loc , const std::string &message) 
{				
	// Location should be initialized inside scanner action, but is not in this example.
	// Let's grab location directly from driver class.
	// cout << "Error: " << message << endl << "Location: " << loc << endl;
	
	cout << "Error: " << message << endl << "Error location: " << driver.location() << endl;
}
