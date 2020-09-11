#ifndef PARSER_TYPES_H
#define PARSER_TYPES_H

#include <string>
#include <string_view>

namespace noscratch {

struct text {
	enum class type {
		glob  = 'g',  // Glob expression (#,*)
		regex = 'r',  // Regular expression
		plain,
	};
	type        t;
	std::string body;
	static type detect_type(const std::string_view sw);
};

struct indent {
	enum class type {
		space,
		tab,
	};
	type   t;
	size_t sz;
};

} // no

#endif // PARSER_TYPES_H