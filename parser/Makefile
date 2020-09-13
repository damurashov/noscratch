all:
	flex -o scanner.cpp ./flexbison/scanner.l
	bison -o parser.cpp ./flexbison/parser.y

clean:
	rm -rf scanner.cpp
	rm -rf parser.cpp parser.hpp location.hh position.hh stack.hh