#include "types.h"

using namespace noscratch;

text::type text::detect_type(const std::string_view sw)
{
    type t;

    switch (sw[0]) {
        case type::glob:
            t = type::glob;
            break;
        case type::regex:
            t = type::regex;
            break;
        default:
            t = type::plain;
            break;
    }

    return t;
}