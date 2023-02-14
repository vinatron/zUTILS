/******************************************************
*       SUBMIT EXEC WRITTEN BY VINCENT F. MANZO       *
*                  DECEMBER 9 2022                    *
*               UPDATE FEBUARY 13 2023                *
* A PROGRAM FOR ASSISTING STARTING UR DEVICES FOR VSE *
******************************************************/

TRACE E                                      /* ERROR TRACING */

/* GRAB ARGUMENTS */
PARSE ARG USERID FN FT FM 

/* BANNER START */
SAY "STARTING VINATRON'S VSE UR MANAGMENT FACILITY"
SAY 'PROPERTY OF:'                           /* BANNER */
SAY 'VINATRON TECHNOLOGY AND ELECTRICAL'     /* BANNER END */

SIGNAL ON ERROR                              /* TEST RC OF COMMANDS */

TEST_ARG:                                    /* ARGUMENT TESTS MARKER */
IF LENGTH(USERID) = 0 THEN DO                /* TEST ARG USERID */
 SAY 'WHAT USERID IS THE GUEST?'             /* REQUEST INPUT */
 PULL USERID                                 /* STORE USERID */
 SIGNAL TEST_ARG                             /* JUMP TO TEST_ARG */
END                                          /* END IF TEST ARG */
IF LENGTH(FN) = 0 THEN DO                    /* TEST ARG FN */
 SAY 'WHAT IS THE FILE NAME?'                /* REQUEST INPUT */
 PULL FN                                     /* STORE FN */
 SIGNAL TEST_ARG                             /* JUMP TO TEST_ARG */
END                                          /* END IF TEST ARG */
IF LENGTH(FT) = 0 THEN DO                    /* TEST ARG FT */
 SAY 'WHAT IS THE FILE TYPE?'                /* REQUEST INPUT */
 PULL FT                                     /* STORE FT */
 SIGNAL TEST_ARG                             /* JUMP TO TEST_ARG */
END                                          /* END IF TEST ARG */
IF LENGTH(FM) = 0 THEN DO                    /* TEST ARG FM */
 SAY 'WHAT IS THE FILE MODE?'                /* REQUEST INPUT */
 SAY 'E.G. A'                                /* REQUEST INPUT */      
 PULL FT                                     /* STORE FM */
 SIGNAL TEST_ARG                             /* JUMP TO TEST_ARG */
END                                          /* END IF TEST ARG */

/* NOTIFY USER */
SAY 'SUBMITTING JCL:' FN FT FM 'TO USER:' USERID"'S READER"
'CP SPOOL PUNCH' USERID                      /* SPOOL PUNCH TO USERID */                   
'CP WAIT 1 SEC'                              /* WAIT 1 SECOND */
'CP SPOOL PUNCH READER'                      /* SPOOL PUNCH TO READER */
'CP WAIT 1 SEC'                              /* WAIT 1 SECOND */
'CP PUNCH' FN FT FM '(NOH'                   /* PUNCH DILE TO USERS READER */

EXIT                                         /* END PROGRAM */
