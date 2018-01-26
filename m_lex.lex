%option noyywrap
%option never-interactive
%option nounput
%option noinput

%{
	#include "lex.h"

	int charcount = 0;
	int linecount = 0;
%}

digit			[0-9]
alpha			[a-zA-Z]
quote			["]
char			[^_A-Za-z0-9]

%%
[ \t|" "]	{ charcount++;		}
[ \n]		{ linecount++; 		}

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
\|			{ return tSLASH; 	}

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

"#"[_{digit}{alpha}]*		{ return tCID; 	}
{alpha}[_{digit}{alpha}]*	{ return tID; 	}
{digit}+"."{digit}+			{ return tRVAL; }
{digit}+					{ return tIVAL; }
"false"						{ return tBVAL; }
"true"						{ return tBVAL; }
{quote}{char}{quote}		{ return tCVAL; }
{quote}"\n"{quote}			{ return tCVAL; }
{quote}"\t"{quote}			{ return tCVAL; }
	
%%

TokenRecord * getToken(void){
	TokenRecord * token = malloc(sizeof(TokenRecord));
	if (token == NULL)
		exit(1);

	charcount += strlen(yytext);
	token->charpos = charcount;
	token->linepos = linecount;
	
	bool b = true;
	switch (yylex()){
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
