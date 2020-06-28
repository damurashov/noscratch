snazzle: lex.yy.c snazzle.tab.c snazzle.tab.h
	g++ -std=c++14 snazzle.tab.c lex.yy.c -lfl -o snazzle

snazzle.tab.c snazzle.tab.h: snazzle.y
	bison -d snazzle.y

lex.yy.c: snazzle.l
	flex snazzle.l

clean:
	rm lex.yy.c snazzle.tab.*
