cc	= gcc
arch 	= ar
lexer	= flex
std 	= c11
P_FLAG	= -d


all: command

command: lex.yy.c
	$(cc) -std=$(std) -Wall -Werror lex_tester.c lex.yy.c

lex.yy.c: m_lex.lex
	$(lexer) m_lex.lex

clean:
	rm -f lex.yy.c a.out
