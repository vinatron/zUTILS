/********************************************
* VINATRON EXEC WRITTEN BY VINCENT F. MANZO *
*             JULY 24 2021                  *
*  A PROGRAM FOR ASSISTING DELETE USERS     *
*********************************************/

TRACE E                                      /* ERROR TRACING */

PARSE ARG USERID

/* BANNER START */
SAY "STARTING VINATRON'S DIRMAINT DELETE USER FACILITY"
SAY 'PROPRETY OF:'                           /* BANNER */
SAY 'VINATRON TECHNOLOGY AND ELECTRICAL'     /* BANNER END */

SIGNAL ON ERROR                              /* TEST RC OF COMMANDS */

IF LENGTH(USERID) = 0 THEN DO                /* TEST ARG USERID */
 SAY 'USERID NAME MUST NOT EXCEED 8 CHAR'    /* REQUEST INPUT */
 PULL USERID                                 /* STORE USERID */
END                                          /* END IF TEST ARG */
TEST_USERID:                                 /* JUMP LABEL */
IF LENGTH(USERID) > 8 THEN DO                /* TEST USERID LENGTH */
 SAY 'INVALID LENGTH INPUT NEW USERID!'      /* NOTIFY USER */
 PULL USERID                                 /* STORE USERID */
 SIGNAL TEST_USERID                          /* JUMP TO LABEL TEST_USERID */
END
'DIRM FOR' USERID 'PURGE'                    /* INVOKE DIRMAINT */


EXIT                                         /* END OF PROGRAM */


/*******************************************************/
/* ERROR HANDLER: COMMON EXIT FOR NONZERO RETURN CODES */
/*******************************************************/
ERROR:
SAY "UNEXPECTED RC" RC "FROM COMMAND:"
SAY "     " SOURCELINE(SIGL)
SAY "AT LINE" SIGL"."
