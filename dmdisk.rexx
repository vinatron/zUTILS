/********************************************
* VINATRON EXEC WRITTEN BY VINCENT F. MANZO *
*             AUGEST 25 2022                *
*  A PROGRAM FOR ASSISTING DELETING MDISK   *
*********************************************/

TRACE E                                      /* ERROR TRACING */

/* GRAB ARGUMENTS */
PARSE ARG USERID ADDR 

/* BANNER START */
SAY "STARTING VINATRON'S DMDISK ASSIST FACILITY"
SAY 'PROPRETY OF:'                           /* BANNER */
SAY 'VINATRON TECHNOLOGY AND ELECTRICAL'     /* BANNER END */

SIGNAL ON ERROR                              /* TEST RC OF COMMANDS */
IF LENGTH(USERID) = 0 THEN DO                /* TEST ARG USERID */
 /* REQUEST INPUT */
 SAY 'WHAT USERID DO YOU WANT TO CREATE A DISK FOR?'
 PULL USERID                                 /* STORE USERID */
END                                          /* END IF TEST ARG */
IF LENGTH(ADDR) = 0 THEN DO                  /* TEST ARG ADDR */
 /* REQUEST INPUT */
 SAY 'WHAT ADDRESS FOR THE DISK EG 191 FOR CMS A DISK'
 PULL ADDR                                   /* STORE ADDR */
END                                          /* END IF TEST ARG */
/* EXECUTE DIRM COMMAND WITH INPUT OPERANDS */
'DIRM FOR' USERID 'DMDISK' ADDR 

EXIT                                         /* END OF PROGRAM */

/*******************************************************/
/* ERROR HANDLER: COMMON EXIT FOR NONZERO RETURN CODES */
/*******************************************************/
ERROR:
SAY "UNEXPECTED RC" RC "FROM COMMAND:"
SAY "     " SOURCELINE(SIGL)
SAY "AT LINE" SIGL"."
