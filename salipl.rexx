/********************************************
* SALIPL EXEC written by VINCENT F. MANZO   *
*             JULY 29 2022                  *
*  A PROGRAM FOR SYSTEMS CUSTOMIZATION      *
*********************************************/

SAY 'ARE YOU SURE YOU WANT TO WRITE A NEW SALIPL TRACK? Y/N'        /* REQUEST INPUT */
SAY 'WARNING!!! DO NOT ATTEMPT UNLESS YOU KNOW WHAT YOU ARE DOING!' /* CONTINUE REQUEST */
PULL ANSWER1                                  /* STORE RESPONCE */
IF ANSWER1 = 'Y' THEN DO                      /* CHECK CONDITONAL 1 */
 SAY 'PREFORMING IPL OF GUESTS: PLEASE WAIT'  /* NOTIFY USER */
 CALL ALLGUESTSIPL                            /* CALL SUB */
 END                                          /* END CONTITONAL 1 */
ELSE                                          /* CHECK CONDITONAL 1 */
 IF ANSWER1 = 'N' THEN DO                     /* CHECK CONDITONAL 1.5 */
  SAY 'WOULD YOU LIKE TO USE THE PANEL INTERFACE? Y/N'/* REQUEST INPUT */
  PULL ANSWER2                                /* STORE RESPONCE */
  IF ANSWER2 = 'Y' THEN                       /* CHECK CONDITONAL 2 */
   SAY 'OK LAUNCHING PANEL: PLEASE WIAT...'   /* NOTIFY USER */
  ELSE                                        /* CHECK CONDITONAL 2 */
   IF ANSWER2 = 'N' THEN DO                   /* CHECK CONDITONAL 2.5 */
    SAY 'LAUNCHING INTERACTIVE MODE: PLEASE WAIT...'    /* NOTIFY USER */
    CALL GUESTIPL                             /* CALL SUB */
    END                                       /* END CONDITONAL 2.5 */
   ELSE
    SAY 'INVALID INPUT TERMINATING'           /* NOTIFY USER */
    END
 ELSE                                         /* CHECK CONDITONAL 1.5 */
  SAY 'INVALID INPUT TERMINATING'             /* NOTIFY USER */
EXIT                                          /* END OF PROGRAM */
