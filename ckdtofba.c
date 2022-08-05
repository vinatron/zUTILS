#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>

/*
 * Convert 3390-{1,3,9} cylinder sizes to FB-512 block sizes, for VM directory entries.
 * A cylinder on a 3390 is 849,960 bytes, and a block on a FB-512 DASD is 512 bytes.
 * Formula: (n * 512) / 849960 
 * Compilation: cc -o ckdtofba ckdtofba.c -lm
 */

const float cylsize_ckd = 849960;
const float cylsize_fba = 512;

int main(int argc, char* argv[]) {
    float input, output, converted_bytes;
    if(argc < 2) {
        fprintf(stderr, "ckdtofba: no CKD cylinder size specified\n");
        exit(1);
    }
    input = atof(argv[1]);
    converted_bytes = input * cylsize_ckd;
    output = converted_bytes / cylsize_fba;
    printf("%f\n", output);
    return 0;
}
