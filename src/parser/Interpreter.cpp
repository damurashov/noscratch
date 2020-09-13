#include "Interpreter.hpp"

using namespace Nosc;
using namespace std;

Interpreter::Interpreter() : 
    m_scanner(*this), m_parser(m_scanner, *this)
{
}

void Interpreter::set_stream(istream &s)
{
    m_scanner.switch_streams(s, NULL);
}

void Interpreter::increase_location(unsigned loc)
{
}