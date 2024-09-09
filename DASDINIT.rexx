/********************************************
* DASDINIT EXEC WRITTEN BY VINCENT F. MANZO *
*             OCTOBER 28 2023               *
*  A PROGRAM FOR FORMATTING DASD IN VM      *
*********************************************/

TRACE E                                      /* ERROR TRACING */

/* GRAB ARGUMENTS */
PARSE ARG CUU VOLSER TYPE CHECK VERBOSE

SAY COPIES('*',80)                           /* BANNER START */
SAY '*' CENTER(" STARTING VINATRON'S DASD FORMAT FACILITY ",76) '*'
SAY '*' CENTER(' PROPERTY OF: ',76) '*'       
SAY '*' CENTER(' VINATRON TECHNOLOGY AND ELECTRICAL ',76) '*' 
SAY COPIES('*',80)                           /* BANNER END */

SIGNAL ON ERROR                              /* TEST RC OF COMMANDS */

IF LENGTH(CUU) = 0 THEN DO                   /* TEST ARG CUU */
 /* REQUEST INPUT */
 SAY 'WHAT IS THE CUU OF THE DISK YOU WANT TO FORMAT?'
 PULL CUU                                    /* STORE CUU */
END                                          /* END IF TEST ARG */
IF LENGTH(VOLSER) = 0 THEN DO                /* TEST ARG VOLSER */
 SAY 'WHAT IS THE VOLSER FOR THE NEW DISK?'  /* REQUEST INPUT */
 PULL VOLSER                                 /* STORE VOLSER */
END                                          /* END IF TEST ARG */
IF LENGTH(TYPE) = 0 THEN DO                  /* TEST ARG TYPE */
 SAY 'WHAT TYPE OF DISK?'                    /* REQUEST INPUT */
 /* DRAW TYPE TABLE */
 SAY COPIES('*',80)
 SAY '*' CENTER(' T = TDISK ' ,76) '*'
 SAY '*' CENTER(' S = SPOOL ',76) '*'
 SAY '*' CENTER(' NULL = PERM ',76) '*'
 SAY COPIES('*',80)
 PULL TYPE                                   /* STORE TYPE */
END                                          /* END IF TEST ARG */

TYPE = TRANSLATE(TYPE)                       /* MAKE TYPE UPPER CASE */

INPUT:                                       /* BEGIN INPUT ERROR HANDLER */
/* CHECK CUU INPUT */
IF (CUU = 0 | LENGTH(CUU) > 4) | (DATATYPE(CUU,X) = 0) THEN DO
 /* REQUEST INPUT */
 SAY 'WHAT IS THE CUU OF THE DISK YOU WANT TO FORMAT? PREVIOUS ENTRY INVALID!'
 PULL CUU                                    /* STORE CUU */
 SIGNAL INPUT                                /* SIGNAL INPUT ERROR DETECTED */
END                                          /* END IF CHECK CUU */
/* CHECK INPUT VOLSER */
IF (LENGTH(VOLSER) = 0) | (DATATYPE(VOLSER,A) = 0)  THEN DO
 /* REQUEST INPUT */
 SAY 'WHAT IS THE VOLSER FOR THE NEW DISK? PREVIOUS ENTRY INVALID!'  
 PULL VOLSER                                 /* STORE VOLSER */
 SIGNAL INPUT                                /* SIGNAL INPUT ERROR DETECTED */
END                                          /* END IF CHECK VOLSER */
/* END INPUT HANDLER */

'QUERY USERID (FIFO'                         /* QUERY FOR CURRENT USERID */
PULL USERID                                  /* PULL DATA OFF THE STACK  */
USERID = SUBWORD(USERID,1,1)                 /* EXTRACT JUST USERID */
ATTED = 0                                    /* SET DEVICE NOT ATTACHED */
DASD = QUEUED()                              /* INIT STACK VAR */
'EXECIO * CP (STRING Q DASD'                 /* PUT Q DASD DATA ON STACK */
DO WHILE QUEUED() > DASD                     /* LOOP THROUGH OUTPUT ON STACK */
 PULL . ADDR ATT . WHO .                     /* PULL Q DASD INFO OFF STACK */ 
 IF ADDR = CUU THEN DO                       /* CHECK IF LINE MATCHES CUU */
  IF ATT = 'CP' THEN DO                        /* CNECK IF ATTACHED TO CP */
   SAY 'DASD ATTACHED TO CP TERMINATING!'    /* NOTIFY USER */
   EXIT 401                                  /* END UNAUTHORIZED RETURN CODE */
  END                                        /* END CHECK ATT CP */
  IF ATT = 'ATTACHED' THEN DO            /* CHECK IF ATTACHED TO ANOTHER USER*/
   IF WHO = USERID THEN DO                   /* CHECK WHO IT'S ATTACHED TO */
    SAY 'ALLREADY ATTACHED TO USERID'  /* PROCEEDING BECAUSE ALREADY ATTACHED */
    ATTED = 1                                /* SET ATTACHED 1 */
   END                                       /* END ATTACHED TO ME */
   ELSE DO                                   /* SOMEONE ELSE DISK*/
    SAY 'DASD ATTACHED TO' WHO 'TERMINATING!' /* NOTIFY USER */
    EXIT 401                                 /* EXIT UNAUTHORIZED RETURN CODE */
   END                                       /* END SOMEONE ELSE */
  END                                        /* END ATTACHED */
 END                                         /* END CUU FOUND */
END                                          /* END LOOP */
IF ATTED /= 1 THEN DO                        /* IF NOT ATTACHED */
 'ATTACH' CUU '*' CUU                        /* ATTACH CUU TO USERID */
END                                          /* END IF NOT ATTACHED */

IF LENGTH(CHECK) = 0 THEN DO                  /* TEST ARG TYPE */
 /* DRAW TABLE */
 SAY COPIES('*',80)
 SAY '*' CENTER(' THE SYSTEM WILL NOW FORMAT ' CUU VOLSER TYPE ,76) '*'
 SAY '*' CENTER(' Y = PROCEED ',76) '*'
 SAY '*' CENTER(' N = TERMINATE ',76) '*'
 SAY COPIES('*',80)
 PULL CHECK                                  /* STORE CHECK */
 CHECK = TRANSLATE(CHECK)                    /* MAKE CHECK UPPERCASE */
 SELECT                                      /* START SWITCH STATEMENT INPUT*/
   WHEN CHECK = 'Y' THEN 'VMFCLEAR'          /* CLEAR SCREEN AND CONTINUE */
   WHEN CHECK = 'N' THEN DO                  /* HANDLE NORMAL TERM */
      'VMFCLEAR'                             /* CLEAR SCREEN */
      EXIT 0                                 /* TERMINATE NORMAL */
   END                                       /* END NORMAL TERM */
   OTHERWISE                                 /* HANDLE INVALID INPUT */
      'VMFCLEAR'                             /* CLEAR SCREEN */
      SAY 'INVALID OPTION TERMINATING!'      /* NOTIFY USER */                  
      EXIT 1                                 /* TERMINATE RC1 */
 END                                         /* END SWITCH STATEMENT INPUT */
END                                          /* END IF TEST ARG */


/* EXECUTE CPFMTXA COMMAND WITH INPUT OPERANDS */
/* QUEUE DATA ON STACK */
QUEUE 'FORMAT'                            
QUEUE CUU
QUEUE '0-END'
QUEUE VOLSER
QUEUE 'YES'
SELECT                                       /* START OF SWITCH STATEMENT */
 WHEN TYPE = 'S' THEN QUEUE 'SPOL 0 END'     /* IF FORMAT = SPOOL */
 WHEN TYPE = 'T' THEN QUEUE 'TDSK 1 END'     /* IF FORMAT = TDISK */
 OTHERWISE QUEUE 'PERM 0 END'                /* DEFAULT PERMDISK */
END                                          /* END OF SWITCH STATEMENT */
QUEUE 'END'
IF VERBOSE /= 1 THEN DO                      /* SUPRESS VERBOSITY */
 "VMFCLEAR"                                  /* CLEAR SCREEN */
 SAY "PROCESSING WITH MESSAGE SUPRESSION. WAIT FOR COMPLETE MESSAGES....."
 'SET CMSTYPE HT'                            /* SUPRESS MESSAGES */
END                                          /* SUPPRESS VERBOSITY */
'CPFMTXA'                                    /* INVOKE CPFMTXA */
RC1 = RC                                     /* STORE FORMAT RC */
'DETACH' CUU                                 /* DETACH CUU FROM USERID */
RC2 = RC                                     /* STORE DRTACH RC */
IF VERBOSE /= 1 THEN 'SET CMSTYPE RT'        /* RESUME OUTPUT */
IF VERBOSE /= 1 THEN "VMFCLEAR"              /* CLEAR SCREEN */
SELECT                                       /* SWITCH STATEMENT INFO */
 WHEN TYPE = S THEN DO                       /* IF TYPE SPOOL */
  SAY 'ADD THE FOLLOWING LINE TO SYSTEM CONFIG:'
  SAY 'CP_Owned   Slot   XXX' VOLSER
  SAY 'REPLACE XXX WITH ANY AVALABLE SLOT.'
 END                                         /* END IF SPOOL */
 OTHERWISE DO                                /* PERM OR TDISK */
  SAY 'ADD THE FOLLOWING LINE TO SYSTEM CONFIG:'
  SAY 'User_Volume_List' VOLSER
  SAY 'UNLESS User_Volume_Include STATEMENT IS IN PLACE.'
 END                                         /* END PERM OR TDISK */
END                                          /* END SWITCH STATEMENT INFO */
SAY "PROGAM COMPLETE LAST RC" RC             /* NOTIFY USER */
EXIT                                         /* END OF PROGRAM */

/*******************************************************/
/* ERROR HANDLER: COMMON EXIT FOR NONZERO RETURN CODES */
/*******************************************************/
ERROR:
SAY "UNEXPECTED RC" RC "FROM COMMAND:"
SAY "     " SOURCELINE(SIGL)
SAY "AT LINE" SIGL"."