install: lang
	mv ./lang ~/_stackparser/docs
	rm lex.yy.c

lang: lex.yy.c
	g++ lex.yy.c -lfl -o lang

lex.yy.c: lang.l
	flex lang.l
