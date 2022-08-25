/********************************************
* VINATRON EXEC WRITTEN BY VINCENT F. MANZO *
*             JULY 24 2021                  *
*  A PROGRAM FOR ASSISTING GET ALL USERS    *
*********************************************/

TRACE E                                      /* ERROR TRACING */

PARSE ARG PASSWD PRT PRTCLASS 

/* BANNER START */
SAY "STARTING VINATRON'S DIRMAINT GET ALL USER FACILITY"
SAY 'PROPRETY OF:'                           /* BANNER */
SAY 'VINATRON TECHNOLOGY AND ELECTRICAL'     /* BANNER END */

SIGNAL ON ERROR                              /* TEST RC OF COMMANDS */

IF LENGTH(PASSWD) = 0 THEN DO                /* TEST ARG PASSWD */
 SAY 'WITHPASS OR NOPASS?'                   /* REQUEST INPUT */
 PULL PASSWD                                 /* STORE PASSWORD */
END                                          /* END IF TEST ARG */
IF LENGTH(PRT) = 0 THEN DO                   /* TEST ARG PRT */
 SAY 'PRINT Y/N?'                            /* REQUEST INPUT */
 PULL PRT                                    /* STORE PRT */
END                                          /* END IF TEST ARG */
/* TEST ARG PRTCLASS */
IF (LENGTH(PRT) /= 0) & (LENGTH(PRTCLASS) = 0) THEN DO                   
 SAY 'INPUT PRINTER CLASS'                   /* REQUEST INPUT */
 PULL PRTCLASS                               /* STORE PRTCLASS */
END                                          /* END IF TEST ARG */
TEST_PASSWD:                                     /* JUMP LABEL */
IF PASSWD /= ('WITHPASS') | ('NOPASS') THEN DO   /* TEST PASSWD INPUT */            
 SAY 'INVALID ARGUMENT ENTER WITHPASS OR NOPASS' /* NOTIFY USER */
 PULL USERID                                     /* STORE PASSWD */
 SIGNAL TEST_PASSWD                              /* JUMP TO LABEL TEST_PASSWD */
END                                              /* ENDIF */
TEST_PRT:                                        /* JUMP LABEL */
IF PRT /= ('Y') | ('N') THEN DO                  /* TEST PRT INPUT */
 SAY 'INVALID ARGUMENT ENTER Y/N FOR PRINTING'   /* NOTIFY USER */
 PULL PRT                                        /* STORE PRT */
 SIGNAL TEST_PRT                                 /* JUMP LABEL TEST_PRT */
END                                              /* ENDIF */
TEST_PRTCLASS:                                   /* JUMP LABEL */
/* TEST PRTCLASS INPUT */
IF ((DATATYPE(PRTCLASS) /= 'CHAR') | (LENGTH(PRTCLASS) /= 1)) & (PRT = 'Y') THEN 
DO
 SAY 'INVALID INPUT PLEASE ENTER ALPHA CHAR'     /* NOTIFY USER */
 PULL PRTCLASS                                   /* STORE PRTCLASS */
 SIGNAL TEST_PRTCLASS                            /* JUMP LABEL TEST_PRTCLASS */
END                                              /* ENDIF */
IF PRT = 'Y' THEN DO                         /* EVALUATE PRT */
 SAY 'GETTING FULL DIRECTORY PLEASE WAIT...' /* NOTIFY USER */
 'PURGE RDR ALL'                             /* CLEAR FILES FROM RDR */
 'DIRM USER' PASSWD                          /* INVOKE DIRMAINT */
 'RECIEVE = USER' PASSWD '(REPLACE'          /* RECIEVE FILE FROM READER */
 'SPOOL PRINTER SYSTEM'                      /* SPOOL PRINTER TO SYSTEM */
 'SPOOL PRINTER CLASS' PRTCLASS              /* SPOOL PRINTER TO PRTCLASS VAR */ 
 'PRINT USER' PASSWD '(NOH'                  /* PRINT FILE */
END                                          /* ENDIF */
IF PRT = 'N' THEN DO                         /* EVALUATE PRT */
 SAY 'GETTING FULL DIRECTORY PLEASE WAIT...' /* NOTIFY USER */
 'PURGE RDR ALL'                             /* CLEAR FILES FROM RDR */
 'DIRM USER' PASSWD                          /* INVOKE DIRMAINT */
 'RECIEVE = USER' PASSWD '(REPLACE'          /* RECIEVE FILE FROM READER */
END                                          /* ENDIF */

/*******************************************************/
/* ERROR HANDLER: COMMON EXIT FOR NONZERO RETURN CODES */
/*******************************************************/
ERROR:
SAY "UNEXPECTED RC" RC "FROM COMMAND:"
SAY "     " SOURCELINE(SIGL)
SAY "AT LINE" SIGL"."