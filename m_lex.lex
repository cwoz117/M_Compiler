%option noyywrap
%option never-interactive
%option nounput
%option noinput
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
