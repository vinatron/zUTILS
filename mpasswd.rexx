/***********************************************
*  VINATRON EXEC WRITTEN BY VINCENT F. MANZO   *
*               AUGEST 25 2022                 *
*  A PROGRAM FOR ASSISTING CHANGING PASSWORDS  *
***********************************************/

TRACE E                                      /* ERROR TRACING */

/* BANNER START */
SAY "STARTING VINATRON'S DIRMAINT PASSWD FACILITY"
SAY 'PROPRETY OF:'                           /* BANNER */
SAY 'VINATRON TECHNOLOGY AND ELECTRICAL'     /* BANNER END */

SIGNAL ON ERROR                              /* TEST RC OF COMMANDS */

MAIN:                                        /* JUMP LABEL */
SAY 'USERID NAME MUST NOT EXCEED 8 CHAR'     /* REQUEST INPUT */
PULL USERID                                  /* STORE USERID */
/* REQUEST INPUT */
SAY 'PASSWORD FOR USERID MUST NOT EXCEED 8 CHAR'
PULL PASSWD                                  /* STORE PASSWORD */
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
SAY 'WOULD YOU LIKE TO CHANGE ANOTHER Y/N'
PULL CONT                                
TEST_CONT:                                   /* JUMP LABEL */
/* TEST CONT INPUT VALID */
IF ((CONT \= 'Y') | (CONT /= 'y')) | ((CONT \= 'N') | (CONT \= 'N')) THEN DO
 SAY 'INVALID INPUT PLEASE ENTER Y OR N!'    /* NOTIFY USER */
 PULL CONT                                   /* STORE CONT */
 SIGNAL TEST_CONT                            /* JUMP TO LABEL TEST_CONT */
END                                          /* END IF TEST INPUT */
IF (CONT = 'Y') | (CONT = 'y') THEN DO       /* TEST IF CONT = Y */
 SAY 'CONTINUING....'                        /* NOTIY USER */
 SIGNAL MAIN                                 /* JUMP TO LABEL MAIN */
END                                          /* END IF TEST CONT */
IF (CONT = 'N') | (CONT = 'n') THEN DO       /* TEST CONT = N */
 SAY 'TERMINATING....'                       /* NOTIFY USER */
END                                          /* END IF TEST CONT */
EXIT                                         /* END OF PROGRAM */


/*******************************************************/
/* ERROR HANDLER: COMMON EXIT FOR NONZERO RETURN CODES */
/*******************************************************/
ERROR:
SAY "UNEXPECTED RC" RC "FROM COMMAND:"
SAY "     " SOURCELINE(SIGL)
SAY "AT LINE" SIGL"."
