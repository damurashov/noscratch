#ifndef PARSER_INTERPRETER_HPP
#define PARSER_INTERPRETER_HPP

#include <sstream>
#include <optional>

#include "scanner.h"
#include "parser.hpp"
#include "ExecutionSequence.hpp"

namespace Nosc {

class Interpreter {
public:
	Interpreter();
	std::optional<ExecutionSequence> run();
	void set_stream(std::istream &is);

private:
	void increase_location(unsigned loc);

	Scanner m_scanner;
	Parser  m_parser;
};

} // Nosc

#endif // PARSER_INTERPRETER_HPP