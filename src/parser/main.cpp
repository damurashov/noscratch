#include <iostream>
#include "Interpreter.hpp"
#include <sstream>

using namespace std;

int main(void)
{
    Nosc::Interpreter interpreter;
    stringstream ss;
    ss << "fragment";
    interpreter.set_stream(ss);
    interpreter.run();

    return 0;
}