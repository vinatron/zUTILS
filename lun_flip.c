/*
 * LUN ID flipper for fibre channel targets.
 * Author: HackerSmacker (7/29/22)
 * Target system: any
 */

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

/*
   0x000000000000000A
   0x000A000000000000
*/

int main(int argc, char* argv[]) {
    char chunks[4][4]; /* parts of the LUN ID */
    int i, j, k; /* loop counters */

    if(argc < 2) {
        fprintf(stderr, "usage: %s [LUN ID]\n", argv[0]);
        fprintf(stderr, "example: ./lunflip 000000000000000A\n");
        exit(1);
    }

    if(strlen(argv[1]) != 16) {
        fprintf(stderr, "erorr: LUN ID is of the wrong length\n");
    }
        

    k = 0; /* Reset the input counter */

    /* Load the values from the string into the arrays */
    for(i = 0; i < 4; i++) {
        for(j = 0; j < 4; j++) {
            chunks[i][j] = argv[1][k];
            k++;
        }
    }

    /* Go back and print the arrays, which do not have null terminators */
    for(i = 0; i < 4; i++) {
        for(j = 3; j >= 0; j--) {
            printf("%c", chunks[i][j]);
        }
    }

    return 0;
}


