#ifndef PARSER_INTERPRETER_HPP
#define PARSER_INTERPRETER_HPP

#include <sstream>
#include "scanner.h"
#include "parser.hpp"

namespace Nosc {

class Interpreter {
public:
	void run();
	void set_input(std::istream &is);

private:
	Scanner m_scanner;
	Parser  m_parser;
};

} // Nosc

#endif // PARSER_INTERPRETER_HPP