/***********************************************
*  VINATRON EXEC WRITTEN BY VINCENT F. MANZO   *
*               AUGEST 25 2022                 *
*  A PROGRAM FOR ASSISTING CHANGING PASSWORDS  *
***********************************************/

TRACE E                                      /* ERROR TRACING */

PARSE ARG USERID PASSWD

/* BANNER START */
SAY "STARTING VINATRON'S DIRMAINT PASSWD FACILITY"
SAY 'PROPRETY OF:'                           /* BANNER */
SAY 'VINATRON TECHNOLOGY AND ELECTRICAL'     /* BANNER END */

SIGNAL ON ERROR                              /* TEST RC OF COMMANDS */

IF LENGTH(USERID) = 0 THEN DO                /* TEST ARG USERID */
 SAY 'USERID NAME MUST NOT EXCEED 8 CHAR'    /* REQUEST INPUT */
 PULL USERID                                 /* STORE USERID */
END                                          /* END IF TEST ARG */
IF LENGTH(PASSWD) = 0 THEN DO                /* TEST ARG PASSWD */
 /* REQUEST INPUT */
 SAY 'PASSWORD FOR USERID MUST NOT EXCEED 8 CHAR'
 PULL PASSWD                                 /* STORE PASSWORD */
END                                          /* END IF TEST ARG */
TEST_USERID:                                 /* JUMP LABEL */
IF LENGTH(USERID) > 8 THEN DO                /* TEST USERID LENGTH */
 SAY 'INVALID LENGTH INPUT NEW USERID!'      /* NOTIFY USER */
 PULL USERID                                 /* STORE USERID */
 SIGNAL TEST_USERID                          /* JUMP TO LABEL TEST_USERID */
END
TEST_PASSWD:                                 /* JUMP LABEL */
IF LENGTH(PASSWD) > 8 THEN DO                /* TEST PASSWORD LENGTH */
 SAY 'INVALID LENGTH INPUT NEW PASSWORD!'    /* NOTIFY USER */
 PULL PASSWD                                 /* STORE PASSWORD */
 SIGNAL TEST_PASSWD                          /* JUMP TO LABEL TEST_PASSWD */
END
'DIRM FOR' USERID 'PW' PASSWD                /* INVOKE DIRMAINT */


EXIT                                         /* END OF PROGRAM */


/*******************************************************/
/* ERROR HANDLER: COMMON EXIT FOR NONZERO RETURN CODES */
/*******************************************************/
ERROR:
SAY "UNEXPECTED RC" RC "FROM COMMAND:"
SAY "     " SOURCELINE(SIGL)
SAY "AT LINE" SIGL"."
