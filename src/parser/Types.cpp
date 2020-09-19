#include "Types.hpp"

using namespace Nosc;

Text::Type Text::detect_type(const std::string_view sw)
{
	Type t = Type::plain;

	if (!sw.empty()) {
		switch (static_cast<Text::Type>(sw[0])) {
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
	}

	return t;
}