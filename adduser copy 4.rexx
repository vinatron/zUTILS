/********************************************
* VINATRON EXEC WRITTEN BY VINCENT F. MANZO *
*             JULY 24 2021                  *
*  A PROGRAM FOR ASSISTING ADDING USERS     *
*********************************************/

TRACE E                                      /* ERROR TRACING */

PARSE ARG USERID PASSWD

/* BANNER START */
SAY "STARTING VINATRON'S DIRMAINT ADD USER FACILITY"
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
CALL COPY_FILE                               /* CALL SUB */
CALL UPDATEPARMS                             /* CALL SUB */
'DIRM ADD' USERID                            /* INVOKE DIRMAINT */
'CP SLEEP 20 SEC'                            /* SLEEP 20 SECOUNDS */
CALL MOVE_FILE                               /* MOVE DIRECTORY FILE */
'AMDISK' USERID 191                          /* INVOKE AMDISK ASSIST FACILITY */

EXIT                                         /* END OF PROGRAM */

/********************************************
* COPY DEFAULT DIRECT TEMPLATE SUBROUTINE   *
*********************************************/
COPY_FILE:
 SAY 'COPYING TEMPLATE TO:' USERID 'DIRECT A'         /* NOTIFY USER*/
 'COPY DEFAULT DIRECT A' USERID 'DIRECT A (REPLACE'   /* INVOKE COPY */
RETURN

/********************************************
* UPDATE PARAMETERS SUBROUTINE              *
*********************************************/
UPDATEPARMS:
 SAY 'UPDATING USERID AND PASSWORD LINE FROM TEMPLATE' /* NOTIFY USER */
 FILE = USERID 'DIRECT A'                              /* FILE VAREABLE */
 DIRECT = LINEIN(FILE)                                 /* GRAB LINE FROM FILE */
 PREFIX = SUBWORD(DIRECT,1,1)                          /* GRAB LINE PREFIX */
 SUFFEX = SUBWORD(DIRECT,4,3)                          /* GRAB LINE SUFFEX */
 LINE = PREFIX USERID PASSWD SUFFEX                    /* CONSTRUCT NEW LINE */
 CALL LINEOUT FILE,LINE,1                              /* WRITE LINE TO FILE */
 CALL LINEOUT FILE                                     /* CLOSE FILE */
 SAY 'WROTE:' LINE                                     /* NOTIFY USER */
 SAY 'TO FILE:' FILE                                   /* NOTIFY USER */
RETURN

/********************************************
* MOVE DIRECTORY TO D DISK SUBROUTINE       *
* DISABLE IF FUNCTONALITY NOT DESIRED BY:   *
* COMMENTING CALL MOVE_FILE                 *
*********************************************/
MOVE_FILE:
 SAY 'MOVING DIRECT FILE TO D DISK'           /* NOTIFY USER */
 'COPY' USERID 'DIRECT A = = D (REPLACE'      /* INVOKE COPY */
 'ERASE' USERID 'DIRECT A'                    /* INVOKE ERASE */
RETURN

/*******************************************************/
/* ERROR HANDLER: COMMON EXIT FOR NONZERO RETURN CODES */
/*******************************************************/
ERROR:
SAY "UNEXPECTED RC" RC "FROM COMMAND:"
SAY "     " SOURCELINE(SIGL)
SAY "AT LINE" SIGL"."
