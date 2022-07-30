/********************************************
* SALIPL EXEC written by VINCENT F. MANZO   *
*             JULY 29 2022                  *
*  A PROGRAM FOR SYSTEMS CUSTOMIZATION      *
*********************************************/

SAY 'ARE YOU SURE YOU WANT TO WRITE A NEW SALIPL TRACK? Y/N'        /* REQUEST INPUT */
SAY 'WARNING!!! DO NOT ATTEMPT UNLESS YOU KNOW WHAT YOU ARE DOING!' /* CONTINUE REQUEST */
PULL ANSWER1                                  /* STORE RESPONCE */
IF ANSWER1 = 'Y' THEN DO                      /* CHECK CONDITONAL 1 */
 CALL SALIPL                                  /* CALL SUB */
 END                                          /* END CONTITONAL 1 */
ELSE                                          /* CHECK CONDITONAL 1 */
 IF ANSWER1 = 'N' THEN DO                     /* CHECK CONDITONAL 1.5 */
  SAY 'TERMINATED BY USER'                    /* REQUEST INPUT */
  END
 ELSE                                         /* CHECK CONDITONAL 1.5 */
  SAY 'INVALID INPUT TERMINATING'             /* NOTIFY USER */
EXIT                                          /* END OF PROGRAM */
/********************************************
* INTERACTIVE SALIPL SUBROUTINE             *
*********************************************/
SALIPL:
 SAY 'WHATS THE IODEVICE OF THE FCP CHANNEL?' /* REQUEST INPUT */
 PULL IODEV                                   /* STORE DEVICE CHANNEL */
 SAY 'WHAT CPLOAD MODULE DO YOU WANT TO LOAD? /* REQUEST INPUT */
 SAY 'DEFAULT IS CPLOAD PLEASE INPUT DEFAULT IF YOU DONT KNOW' /* CONTINUE REQUEST */
 PULL CPLOAD                                  /* STORE CPLOAD MODULE */
 SAY 'INPUT WWPN OF STORAGE TARGET'           /* REQUEST INPUT */
 PULL WWPN                                    /* STORE WWPN */
 SAY 'INPUT LUN FOR RES VOLUME'               /* REQUEST INPUT */
 PULL LUN                                     /* STORE LUN */
 SAY 'INPUT EDEV ADDRESS FOR SYSTRES'         /* REQUEST INPUT */
 PULL EDEV                                    /* STORE EDEV ADDR */
 SAY 'INPUT CONSOLE ADDRESS'                  /* REQUEST INPUT */
 PULL CONS                                    /* STORE CONSOLE ADDRESS */
 SAY 'WRIGHTING SALIPL TRACK WITH SPECIFIED PARMS' /* NOTIFY USER */
 'SALIPL' IODEV '(MODULE' CPLOAD 'OFFSET 0 ORIGN 2000 WWPN' WWPN 'LUN' LUN 'DEVICE' EDEV 'IPLPARMS CONS=' CONS 'PDVOL=' EDEV
RETURN                                        /* END OF SUB */
