#include "types.h"

using namespace Nosc;

Text::Type Text::detect_type(const std::string_view sw)
{
    Type t;

    switch (sw[0]) {
        case Type::glob:
            t = Type::glob;
            break;
        case Type::regex:
            t = Type::regex;
            break;
        default:
            t = Type::plain;
            break;
    }

    return t;
}