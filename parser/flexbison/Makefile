install: lang
	mv ./lang ~/_stackparser/docs
	rm lex.yy.c
	~/_stackparser/docs/lang ~/_stackparser/docs/example.stack

lang: lex.yy.c
	g++ lex.yy.c -lfl -o lang

lex.yy.c: lang.l
	flex lang.l
