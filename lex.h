#ifndef LEX_H

#include <stdio.h>
#include <string.h>
#include <stdbool.h>
#include <stdlib.h>

typedef enum {
	tADD,   tSUB,   tMUL,   tDIV,   tARROW, tAND,    tOR,   tNOT,
	tEQUAL, tLT,    tGT,    tLE,    tGE,    tASSIGN, tLPAR, tRPAR, 
	tCLPAR, tCRPAR, tSLPAR, tSRPAR, tSLASH, tCOLON,  tSEMICOLON,
	tCOMMA, tIF,    tTHEN,  tWHILE, tDO,    tREAD,   tELSE, tFUN,
	tBEGIN, tEND,   tCASE,  tOF,    tPRINT, tINT,    tBOOL, tCHAR,
	tREAL,  tVAR,   tDATA,  tSIZE,  tFLOAT, tFLOOR,  tCEIL, tRETURN,
	tCID,   tID,    tRVAL,  tIVAL, 	tBVAL, 	tCVAL, tEOF
} TokenType;

typedef struct {
	TokenType tokenval;
	
	int charpos;
	int linepos;
	
	union {
		char * stringval;
		int    intval;
		float  floatval;
		bool   boolval;
	} attribute;
	
}TokenRecord;

TokenRecord * getToken(void);
int multicomment(void);
int inputpos(char value);
#endif
