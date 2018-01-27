%option noyywrap
%option never-interactive
%option nounput
/* %option yylineno */

%{
	#include "lex.h"


	int linecount = 1;
	int charcount = 1;
	
%}

digit			[0-9]
alpha			[a-zA-Z]
quote			["]
char			[^_A-Za-z0-9]
identifier		({alpha}({alpha}|{digit})*)

%%
([%](.)*)	{}
("/*")		{ int i = multicomment(); 
			  if (i) printf("Hit EOF in a comment\n");	}
"\n"		{ charcount = 1; linecount++; }
[ \t|" "]	{ charcount++;		}

"+"			{ return tADD; 		}
"-"			{ return tSUB; 		}
"*"			{ return tMUL; 		}
"/"			{ return tDIV; 		}
"=>"		{ return tARROW; 	}
"&&"		{ return tAND; 		}
"||"		{ return tOR; 		}
"not"		{ return tNOT; 		}

"="			{ return tEQUAL; 	}
"<"			{ return tLT; 		}
">"			{ return tGT; 		}
"=<"		{ return tLE; 		}
">="		{ return tGE; 		}

":="		{ return tASSIGN; 	}
"("			{ return tLPAR; 	}
")"			{ return tRPAR; 	}
"{"			{ return tCLPAR; 	}
"}"			{ return tCRPAR; 	}
"["			{ return tSLPAR; 	}
"]"			{ return tSRPAR; 	}
'|'			{ return tSLASH; 	}

":"			{ return tCOLON; 	}
";"			{ return tSEMICOLON;}
","			{ return tCOMMA; 	}

"if"		{ return tIF; 		}
"then"		{ return tTHEN; 	}
"while"		{ return tWHILE; 	}
"do"		{ return tDO; 		}
"read"		{ return tREAD; 	}
"else"		{ return tELSE; 	}
"begin"		{ return tBEGIN; 	}
"end"		{ return tEND; 		}
"case"		{ return tCASE; 	}
"of"		{ return tOF; 		}
"print"		{ return tPRINT; 	}
"int"		{ return tINT; 		}
"bool"		{ return tBOOL; 	}
"char"		{ return tCHAR; 	}
"real"		{ return tREAL; 	}
"var"		{ return tVAR; 		}
"data"		{ return tDATA; 	}
"size"		{ return tSIZE; 	}
"float"		{ return tFLOAT; 	}
"floor"		{ return tFLOOR; 	}
"ceil"		{ return tCEIL; 	}
"fun"		{ return tFUN; 		}
"return"	{ return tRETURN; 	}

<<EOF>>		{return tEOF;}

"false"					{ return tBVAL; }
"true"					{ return tBVAL; }
"#"[{digit}{alpha}]*	{ return tCID; 	}
{identifier}			{ return tID; 	}
{digit}+"."{digit}+		{ return tRVAL; }
{digit}+				{ return tIVAL; }
{quote}{char}{quote}	{ return tCVAL; }
{quote}'\n'{quote}		{ return tCVAL; }
{quote}'\t'{quote}		{ return tCVAL; }

%%

TokenRecord * getToken(void){
	TokenRecord * token = NULL;
	token = calloc(1, sizeof(TokenRecord));
	if (token == NULL)
		exit(1);

	
	token->tokenval = yylex();	
	token->charpos = charcount;
	token->linepos = linecount; //yylineno
	charcount += yyleng;
	
	bool b = true;
	switch (token->tokenval){
		case tIVAL:
			token->attribute.intval = atoi(yytext);
			break;
		case tRVAL:
			token->attribute.floatval = atof(yytext);
			break;
		case tBVAL:
			if (strcmp(yytext, "false") == 0)
				b = false;
			token->attribute.boolval = b;
			break;
		default:
			token->attribute.stringval = yytext;
			break;
	}
	return  token;
}

int inputpos(char value){
	switch (value){
		case '*': return 0;
		case '/': return 1;
		case '\n':
			linecount++; 
			return 2;
		case '%': return 3;
		case EOF: return -1;
		default: return 4;
	}
}

int multicomment(void){
	int transition[6][5] = {
		{1,3,0,2,0},
		{1,5,0,2,0},
		{2,2,0,2,2},
		{4,3,0,2,0},
		{0,0,0,0,0},
		{0,0,0,0,0},
	};
	int error = 0;
	int accept = 5;
	int state = 0;

	int ch = inputpos(input());
	while ((state != accept) && !error){
		if (ch == -1){
			error = 1;
		}else{
			if (state == 4){
				error = multicomment();
				state = 0;
			}
			int newstate = transition[state][ch];
			if (newstate == state){
				ch = inputpos(input());
			} else if (state == 4){
				error = multicomment();
				state = 0;
				ch = inputpos(input());
			} else {
				state = newstate;
				
			}
			if (ch == EOF)
				error = 1;
		}
	}
	return error;
}

/*
							   '*'  '%' '\n'  '/'  other
	base_comment			0|  1    2    0    0     0
	maybe end of comment	1|  1    0    0    3     0
	one line comment		2|  2    2    0    2     2
	accept					3|  0    0    0    0     0     

	state = 1
	ch = next input character
	while not accept-state and not error do
		newstate = T[state, ch]
		if state advances
			ch = next input char
		state = newstate
	end while
	if accept and not error
		accept
*/
