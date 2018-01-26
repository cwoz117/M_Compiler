#include "lex.h"

int main(void){
	
	const char * tokens[] = {
		"tADD", "tSUB","tMUL", "tDIV", "tARROW", "tAND", "tOR", "tNOT",
		"tEQUAL", "tLT", "tGT", "tLE", "tGE", "tASSIGN", "tLPAR", "tRPAR", 
		"tCLPAR", "tCRPAR", "tSLPAR", "tSRPAR", "tSLASH", "tCOLON", "tSEMI",
		"tCOMMA", "tIF", "tTHEN", "tWHILE", "tDO", "tREAD", "tELSE", "tFUN",
		"tBEGIN", "tEND", "tCASE", "tOF", "tPRINT", "tINT", "tBOOL", "tCHAR",
		"tREAL", "tVAR", "tDATA", "tSIZE", "tFLOAT", "tFLOOR", "tCEIL", "tRETURN",
		"tCID", "tID", "tRVAL", "tIVAL", "tBVAL", "tCVAL", "tEOF"
	
	};

	TokenRecord * t = getToken();
	while (t->tokenval != tEOF){
		printf("Line: %-4d Char: %-4d Token: %-10s Value: ", 
				t->linepos, t->charpos, tokens[t->tokenval]);

		switch(t->tokenval){
			case tIVAL:
				printf("%d\n", t->attribute.intval);
				break;
			case tRVAL:
				printf("%f\n", t->attribute.floatval);
				break;
			case tBVAL:
				printf("%s\n ", t->attribute.boolval ? "true": "false");
				break;
			default:
				printf("%s\n", t->attribute.stringval);
				break;
		}

		t = getToken();
	}
}
