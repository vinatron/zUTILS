/********************************************
* VINATRON EXEC WRITTEN BY VINCENT F. MANZO *
*             JULY 24 2021                  *
*  A PROGRAM FOR ASSISTING ADDING MDISK     *
*********************************************/

TRACE E                                      /* ERROR TRACING */

SAY 'STARTING VINATRON'S AMDISK ASSIST'      /* BANNER START */
SAY 'PROPRETY OF:'                           /* BANNER */
SAY 'VINATRON TECHNOLOGY AND ELECTRICAL'     /* BANNER END */

SIGNAL ON ERROR                              /* TEST RC OF COMMANDS */
/* REQUEST INPUT */
SAY 'WHAT USERID DO YOU WANT TO CREATE A DISK FOR?'
PULL USERID                                  /* STORE USERID */
/* REQUEST INPUT */
SAY 'WHAT ADDRESS FOR THE DISK EG 191 FOR CMS A DISK'
PULL ADDR                                    /* STORE ADDR */
SAY 'HOW MANY BLOCKS/CYSL?'                  /* REQUEST INPUT */
PULL EXTENT                                  /* STORE EXTENT */
SAY 'WHAT DASD TYPE FB-512/3390/3380?'       /* REQUEST INPUT */
PULL DTYPE                                   /* STORE DASD TYPE*/
SAY 'WHAT VOLSER TO ALLOCATE FROM?'          /* REQUEST INPUT*/
PULL VOLSER                                  /* STORE VOLSER */
/* EXECUTE DIRM COMMAND WITH INPUT OPERANDS */
'DIRM FOR' USERID 'AMDISK' ADDR DTYPE 'AUTOV' EXTENT VOLSER MW

EXIT                                         /* END OF PROGRAM */

/*******************************************************/
/* ERROR HANDLER: COMMON EXIT FOR NONZERO RETURN CODES */
/*******************************************************/
ERROR:
SAY "UNEXPECTED RC" RC "FROM COMMAND:"
SAY "     " SOURCELINE(SIGL)
SAY "AT LINE" SIGL"."
