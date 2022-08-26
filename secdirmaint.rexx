/***************************************************
*     VINATRON EXEC WRITTEN BY VINCENT F. MANZO    *
*                  AUGEST 25 2022                  *
*  A PROGRAM FOR ASSISTING SECURING WITH DIRMAINT  *
***************************************************/

TRACE E                                      /* ERROR TRACING */

PARSE ARG SYSPASS

/* BANNER START */
SAY "STARTING VINATRON'S SECURE DIRECTORY WITH DIRMAINT FACILITY"
SAY 'PROPERTY OF:'                           /* BANNER */
SAY 'VINATRON TECHNOLOGY AND ELECTRICAL'     /* BANNER END */

SIGNAL ON ERROR                              /* TEST RC OF COMMANDS */

IF LENGTH(SYSPASS) = 0 THEN DO               /* TEST ARG SYSPASS */
/* REQUEST INPUT */
 SAY 'SYSTEM ACCOUNT PASSWORD MUST NOT EXCEED 8 CHAR'   
 PULL SYSPASS                                /* STORE SYSPASS */
END                                          /* END IF TEST ARG */
TEST_SYSPASS:                                /* JUMP LABEL */
IF LENGTH(SYSPASS) > 8 THEN DO               /* TEST PASSWORD LENGTH */
 SAY 'INVALID LENGTH INPUT NEW PASSWORD!'    /* NOTIFY USER */
 PULL SYSPASS                                /* STORE PASSWORD */
 SIGNAL TEST_SYSPASS                         /* JUMP TO LABEL TEST_SYSPASS */
END                                          /* END IF */

/* NOTIFY USER */
SAY 'REMOVING DEFAULT PASSWORDS AND REPLACING WITH' SYSPASS  
FILE = 'USER DIRECT C'                       /* FILE VAREABLE */
LINENUM = 1                                  /* LINE NUMBER VAR */
DO UNTIL LINES(FILE) = 0                     /* PARSE FILE */
 DIRECT = LINEIN(FILE)                       /* GRAB LINE FROM FILE */
/* CHECK IF ON USER LINE */
 IF (SUBWORD(DIRECT,1,1) = 'USER')  & (SUBWORD(DIRECT,3,1) \= 'NOLOG') THEN DO  
  CALL UPDATEPARMS                           /* CALL SUB */
  LINENUM = LINENUM + 1                      /* INCRIMENT LINE COUNTER */ 
 END                                         /* END IF */
 /* CHECK IF ON USER LINE */
 IF (SUBWORD(DIRECT,1,1) = 'IDENTITY') & (SUBWORD(DIRECT,3,1) \= 'AUTOONLY')
 THEN DO
  CALL UPDATEPARMS                           /* CALL SUB */
  LINENUM = LINENUM + 1                      /* INCRIMENT LINE COUNTER */ 
 END                                         /* END IF */
 LINENUM = LINENUM + 1                       /* INCRIMENT LINE COUNTER */
END                                          /* END OF LINES */

SAY 'ALL PASWORDS UPDATED WITH' SYSPASS      /* BEGIN BANNER */
SAY 'THANK YOU FOR USING OUR PRODUCT!'       /* END BANNER */

EXIT                                         /* END OF PROGRAM */

/*******************************************************/
/* ERROR HANDLER: COMMON EXIT FOR NONZERO RETURN CODES */
/*******************************************************/
ERROR:
SAY "UNEXPECTED RC" RC "FROM COMMAND:"
SAY "     " SOURCELINE(SIGL)
SAY "AT LINE" SIGL"."