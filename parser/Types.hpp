#ifndef PARSER_TYPES_H
#define PARSER_TYPES_H

#include <string>
#include <string_view>

namespace Nosc {

struct Text {
	enum class Type {
		glob  = 'g',  // Glob expression (#,*)
		regex = 'r',  // Regular expression
		plain,
	};
	Type        type;
	std::string body;
	static Type detect_type(const std::string_view sw);
};

struct Indent {
	enum class Type {
		space,
		tab,
	};
	Type   type;
	size_t sz;
};

} // Nosc

#if 0
int main(void)
{
	Text::Type type = Text::detect_type("This is a plain string");
	if (type == Text::Type::glob) {
		return 1;
	}
}
#endif

#endif // PARSER_TYPES_H
