#ifndef PARSER_TYPES_H
#define PARSER_TYPES_H

#include <string>
#include <string_view>

namespace Nosc {

struct Text {
	enum class Type {
		Glob  = 'g',  // Glob expression (#,*)
		Regex = 'r',  // Regular expression
		Plain,
	};
	Type        type;
	std::string body;
	static Type detectType(const std::string_view sw);
};

struct Indent {
	enum class Type {
		Space,
		Tab,
	};
	Type   type;
	size_t sz;
};

} // Nosc

#endif // PARSER_TYPES_H
