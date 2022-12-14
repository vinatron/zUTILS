/********************************************
* VINATRON EXEC WRITTEN BY VINCENT F. MANZO *
*             AUGEST 25 2022                *
*  A PROGRAM FOR ASSISTING GETING USERS     *
*********************************************/

TRACE E                                      /* ERROR TRACING */

PARSE ARG USERID 

/* BANNER START */
SAY "STARTING VINATRON'S DIRMAINT GET USER FACILITY"
SAY 'PROPERTY OF:'                           /* BANNER */
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
'PURGE RDR ALL'                              /* DRAIN RDR SPOOL */
'DIRM FOR' USERID 'GET'                      /* INVOKE DIRMAINT */
'CP SLEEP 20 SEC'                            /* SLEEP 20 SECOUNDS */
'RECEIVE =' USERID 'DIRECT'                  /* RECEIVE DIRECT */

EXIT                                         /* END OF PROGRAM */

/*******************************************************/
/* ERROR HANDLER: COMMON EXIT FOR NONZERO RETURN CODES */
/*******************************************************/
ERROR:
SAY "UNEXPECTED RC" RC "FROM COMMAND:"
SAY "     " SOURCELINE(SIGL)
SAY "AT LINE" SIGL"."
