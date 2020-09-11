/* https://www.gnu.org/software/bison/manual/html_node/Calc_002b_002b-Parser.html */

%skeleton "lalr.cc"
%require 3.7.1
%defines
%define api.token.constructor
%define api.value.type variant
%define parse.assert
%define parse.trace
%define parse.error detailed
%define parse.lac full

%{
	#include <string>
	#include "types.h"

%}

%token <noscratch::text>  Regex
%token <noscratch::indent> Indent

%token FRAGMENT
%token FOLLOW
%token TRANSFORM
%token OUT
%token FILTER
%token ENDLS
%token EMPTY_LINE
%token ASTERISK
%token CUSTOM_COMMAND

%%

/* Regex, including syntactic sugar */
regex:
	REGEX
|	ASTERISK
;

/* Optional empty lines */
els:
	els ENDL
|	els INDENT ENDL
|	%empty
;

fragment_declaration:
	els INDENT FRAGMENT REGEX ENDL els;

fragment_block:
	fragment_declaration commands
|	fragment_declaration fragment_block commands
;

/* Commands */
commands:
	els command
|	els commands command
;

command:
	command_body ENDL;

command_body:
	c_transform | c_follow | c_out;

c_transform:
	TRANSFORM regex regex
|	TRANSFORM regex CUSTOM_COMMAND
;

c_follow:
	FOLLOW regex;

c_out:
	OUT REGEX
|	OUT ASTERISK
|	OUT
;


%%


void yy::parser::error(const std::string &m)
{
	std::cerr << l << ": " << m << std::endl;
}