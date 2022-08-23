/********************************************
* VINATRON EXEC WRITTEN BY VINCENT F. MANZO *
*             JULY 24 2021                  *
*  A PROGRAM FOR ASSISTING ADDING MDISK     *
*********************************************/

TRACE E                                      /* ERROR TRACING */

/* GRAB ARGUMENTS */
PARSE ARG USERID ADDR EXTENT DTYPE VOLSER

/* BANNER START */
SAY "STARTING VINATRON'S AMDISK ASSIST FACILITY"
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
IF LENGTH(EXTENT) = 0 THEN DO                /* TEST ARG EXTENT */
 SAY 'HOW MANY BLOCKS/CYSL?'                 /* REQUEST INPUT */
 PULL EXTENT                                 /* STORE EXTENT */
END                                          /* END IF TEST ARG */
IF LENGTH(DTYPE) = 0 THEN DO                 /* TEST ARG DTYPE */
 SAY 'WHAT DASD TYPE FB-512/3390/3380?'      /* REQUEST INPUT */
 PULL DTYPE                                  /* STORE DASD TYPE */
END                                          /* END IF TEST ARG */
IF LENGTH(DTYPE) = 0 THEN DO                 /* TEST ARG VOLSER */
 SAY 'WHAT VOLSER TO ALLOCATE FROM?'         /* REQUEST INPUT */
 PULL VOLSER                                 /* STORE VOLSER */
END                                          /* END IF TEST ARG */
/* EXECUTE DIRM COMMAND WITH INPUT OPERANDS */
'DIRM FOR' USERID 'AMDISK' ADDR DTYPE 'AUTOV' EXTENT VOLSER 'MW'

EXIT                                         /* END OF PROGRAM */

/*******************************************************/
/* ERROR HANDLER: COMMON EXIT FOR NONZERO RETURN CODES */
/*******************************************************/
ERROR:
SAY "UNEXPECTED RC" RC "FROM COMMAND:"
SAY "     " SOURCELINE(SIGL)
SAY "AT LINE" SIGL"."
