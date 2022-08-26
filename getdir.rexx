/********************************************
* VINATRON EXEC WRITTEN BY VINCENT F. MANZO *
*             AUGEST 25 2022                *
*  A PROGRAM FOR ASSISTING GET DIRECTORY    *
*********************************************/

TRACE E                                      /* ERROR TRACING */

PARSE ARG PASSWD PRT PRTCLASS

/* BANNER START */
SAY "STARTING VINATRON'S DIRMAINT GET DIRECTORY FACILITY"
SAY 'PROPERTY OF:'                           /* BANNER */
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
IF (LENGTH(PRTCLASS) = 0) & (PRT = 'Y') THEN DO
 SAY 'ENTER PRINTCLASS'                      /* REQUEST INPUT */
 PULL PRTCLASS                               /* STORE PRTCLASS */
END                                          /* END IF TEST ARG */
TEST_PASSWD:                                 /* JUMP LABEL */
/* TEST WITHPASS OR NOPASS */
IF (PASSWD \= 'WITHPASS') | (PASSWD \= 'NOPASS') THEN DO                
 /* NOTIFY USER */
 SAY 'INVALID ARGUMENT PLEASE INPUT EITHER WITHPASS OR NOPASS!'    
 PULL PASSWD                                 /* STORE PASSWORD */
 SIGNAL TEST_PASSWD                          /* JUMP TO LABEL TEST_PASSWD */
END                                          /* END TEST_PASSWD */
TEST_PRT:                                    /* JUMP LABEL */
IF (PRT \= 'Y') | (PRT \= 'N') THEN DO       /* TEST PRT Y/N */
 SAY 'INVALID ARGUMENT INPUT Y/N!'           /* NOTIFY USER */
 PULL PRT                                    /* STORE PRT */
 SIGNAL TEST_PRT                             /* JUMP TO LABEL TEST_PRT */
END                                          /* END TEST_PRT */
TEST_PRTCLASS:                               /* JUMP LABEL */
/* TEST PRTCLASS CHAR LENGTH 1 WHEN PRT = Y */
IF ((DTAATYPE(PRTCLASS) \= 'CHAR') | (LENGTH(PRTCLASS) \= 1)) & (PRT = 'Y') THEN
DO
 /* NOTIFY USER */
 SAY 'INVALID PRINTER CLASS PLEASE ENTER 1 VALID ALPHA CHARACTURE!'
 PULL PRTCLASS                               /* STORE PRTCLASS */
 SIGNAL TEST_PRTCLASS                        /* JUMP LABEL TEST_PRTCLASS */
END                                          /* END TEST_PRTCLASS */

IF PRT = 'Y' THEN DO                         /* EXECUTE WITH PRINTING */
 'PURGE RDR ALL'                             /* DRAIN USERS RDR SPOOL */
 /* NOTIFY USER */
 SAY 'GETING ENTIRE SYSTEM DIRECTORY' PASSWD 'PLEASE WAIT...'
 'DIRM USER' PASSWD                          /* INVOKE DIRMAINT */
 'CP SLEEP 20 SEC'                           /* SLEEP 20 SECOUNDS */
 SAY 'RECEIVING FILE...'                     /* NOTIFY USER */
 'RECEIVE = USER' PASSWD '(REPLACE'          /* INVOKE RECEIVE */
 /* NOTIFY USER */
 SAY 'SETTING PRINT SPOOL TO SYSTEM AS CLASS:' PRTCLASS 
 'SPOOL PRINTER SYSTEM'                      /* SPOOL PRINTER TO SYSTEM */
 'SPOOL PRINTER CLASS' PRTCLASS              /* SPOOL PRINTER WITH CLASS VAR */
 /* NOTIFY USER */
 SAY 'PRINTING FILE: USER' PASSWD 'WITH CLASS:' PRINTCLASS
 'PRINT USER' PASSWD '(NOH'                  /* PRINT FILE */
END                                          /* END IF */
IF PRT = 'N' THEN DO                         /* EXECUTE WITHOUT PRINTING */
 'PURGE RDR ALL'                             /* DRAIN USERS RDR SPOOL */
 /* NOTIFY USER */
 SAY 'GETING ENTIRE SYSTEM DIRECTORY' PASSWD 'PLEASE WAIT...'
 'DIRM USER' PASSWD                          /* INVOKE DIRMAINT */
 'CP SLEEP 20 SEC'                           /* SLEEP 20 SECOUNDS */
 SAY 'RECEIVING FILE...'                     /* NOTIFY USER */
 'RECEIVE = USER' PASSWD '(REPLACE'          /* INVOKE RECEIVE */
END                                          /* END IF */

EXIT                                         /* END OF PROGRAM */

/*******************************************************/
/* ERROR HANDLER: COMMON EXIT FOR NONZERO RETURN CODES */
/*******************************************************/
ERROR:
SAY "UNEXPECTED RC" RC "FROM COMMAND:"
SAY "     " SOURCELINE(SIGL)
SAY "AT LINE" SIGL"."
