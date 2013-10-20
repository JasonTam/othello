/*=================================================================
 * Jason Tam
 * October 2013
 * An attempt to make my Othello AI faster by using C
 * Syntax in MATLAB:
 *
 *		[ nextBoards, actions] = getAllValid( b, tok )
 *=================================================================*/
#include <math.h>
#include "mex.h"

#include <string.h> /* memset */
#include <unistd.h> /* close */

/* Constants */
#define	L       8
#define	NB_DIMS	3
#define N_DIR   8

/* Input Arguments */
#define	B_IN	prhs[0]
#define	TOK_IN	prhs[1]

/* Output Arguments */
#define	NB_OUT	plhs[0]
#define	A_OUT	plhs[1]

/* Directional Index Modifications */
static int dirIndN (int m, int n, int off){return m-off+L*n;}
static int dirIndS (int m, int n, int off){return m+off+L*n;}
static int dirIndW (int m, int n, int off){return m+L*(n-off);}
static int dirIndE (int m, int n, int off){return m+L*(n+off);}
static int dirIndNW(int m, int n, int off){return m-off+L*(n-off);}
static int dirIndSE(int m, int n, int off){return m+off+L*(n+off);}
static int dirIndNE(int m, int n, int off){return m-off+L*(n+off);}
static int dirIndSW(int m, int n, int off){return m+off+L*(n-off);}

typedef int (*dirFnPtr)(int, int, int );
static dirFnPtr dirFnPtrArr[N_DIR] = {dirIndN,dirIndS,dirIndW,dirIndE,dirIndNW,dirIndSE,dirIndNE,dirIndSW};

/* Directional Boundary Index Checks */
static int bdryN (int m, int n, int off){return m-off>=0;}
static int bdryS (int m, int n, int off){return m+off<L;}
static int bdryW (int m, int n, int off){return n-off>=0;}
static int bdryE (int m, int n, int off){return n+off<L;}
static int bdryNW(int m, int n, int off){return (m-off>=0)&&(n-off>=0);}
static int bdrySE(int m, int n, int off){return (m+off<L)&&(n+off<L);}
static int bdryNE(int m, int n, int off){return (m-off>=0)&&(n+off<L);}
static int bdrySW(int m, int n, int off){return (m+off<L)&&(n-off>=0);}

typedef int (*bFnPtr)(int, int, int );
static bFnPtr bFnPtrArr[N_DIR] = {bdryN,bdryS,bdryW,bdryE,bdryNW,bdrySE,bdryNE,bdrySW};

/* Flips peices */
static int rayFlip( double b[], int m, int n, double tok,
        double potB[], int (*dirFnPtr)(int, int, int), int (*bFnPtr)(int, int, int)) {
    int off = 1;
    int valid = 0;
    while ((*bFnPtr)(m,n,off)&&
            (b[(*dirFnPtr)(m,n,off)]==(-tok))) {
        off++;
    }
    
    if ((off>1)&&(*bFnPtr)(m,n,off)) {
        if (b[(*dirFnPtr)(m,n,off)]==tok) {
            for (;off>0;off--) {potB[(*dirFnPtr)(m,n,off)]=tok;}
            valid = 1;
        }
    }
    
    // Place the actual move down
    if (valid) { potB[m+L*n]=tok; }
    
    return valid;
}
    
/* Attempts to Flip peices */
static int isValid( double	b[], int m, int n, double tok,
        double potB[] ) {
    int valid = 0;
    
    for (int di=0; di<N_DIR; di++) {
        valid += rayFlip( b, m, n, tok, potB, dirFnPtrArr[di], bFnPtrArr[di]);
    }
    
    return valid;
}

/* Get all positions that cause flips */
static int getAllValid( double	*nb, double *a,
           double b[], double tok, double *potB ) {
    int i=0, m=0, n=0, c=0;         // index, row, col, tempiter, count    
   
    for ( n = 0; n < L; n++) {
        for ( m = 0; m < L; m++) {
            i = m+L*n;
            if (b[i]==0) {          // Only analyze for empty spots
                int dila = 0;
                for (int di=0; di<N_DIR; di++)
                    dila += (b[dirFnPtrArr[di](m,n,1)]==(-tok))&&bFnPtrArr[di](m,n,1);
                if (dila) {     // Only analyze for spots touching enemies
                    // Copy potB = b (potB will be modified)
                    memcpy((void *)potB,(const void *)b,L*L*sizeof(double));             

                    if (isValid(b,m,n,tok,potB)>0) { // If it's a valid move
                        a[c] = i+1;     // add the 1 for matlab indexing here
                        // Copy over potential board to a slice of output
                        memcpy((void *)nb+(c++)*L*L*sizeof(double),(const void *)potB,L*L*sizeof(double));
                    }
                }
            }
        }
    }
       
    return c;
}

/* Gateway Function */
void mexFunction( int nlhs, mxArray *plhs[],    /* Input Vars */
		  int nrhs, const mxArray*prhs[] )      /* Output Vars */
{ 
    double *nb,*a;      /* Output Vars */
    double *b,*tok;     /* Input Vars */
    size_t m,n; 

    /* Check for proper number of arguments */
    if (nrhs != 2) { 
	    mexErrMsgIdAndTxt( "MATLAB:getAllValid:invalidNumInputs",
                "Two input arguments required."); 
    } else if (nlhs > 2) {
	    mexErrMsgIdAndTxt( "MATLAB:getAllValid:maxlhs",
                "Too many output arguments."); 
    } 

    /* Check the dimensions of board_in. */ 
    m = mxGetM(B_IN);	// Should be L
    n = mxGetN(B_IN);	// Should be L
    if (!mxIsDouble(B_IN) || mxIsComplex(B_IN) || 
	(m != L) || (n != L)) { 
	    mexErrMsgIdAndTxt( "MATLAB:getAllValid:invalid board",
                "getAllValid requires that Y be a L x L matrix."); 
    } 

    /* Assign pointers to the input parameters */ 
    b = mxGetPr(B_IN); 
    tok = mxGetPr(TOK_IN);

    /* Creating temp variables */ 
    int n_valid;
    double nb_temp[L*L*L*L];
    double a_temp[L*L];
    double potB[L*L];
    
    /* Do the actual computations in a subroutine */
    n_valid = getAllValid(nb_temp,a_temp,b,mxGetScalar(TOK_IN),potB);
    
    /* Create a matrix for the return argument */ 
    const mwSize dims[]={L,L,n_valid};
    NB_OUT = mxCreateNumericArray( NB_DIMS, dims, mxDOUBLE_CLASS, mxREAL);
    A_OUT = mxCreateDoubleMatrix( n_valid, 1, mxREAL); 

    /* Assign pointers to the output parameters */ 
    nb = mxGetPr(NB_OUT);
    a = mxGetPr(A_OUT);
    
    /* Copy over results from tmp variables to output */
    if (n_valid>0) {
        memcpy((void *)nb,(const void *)nb_temp,n_valid*L*L*sizeof(double));
        memcpy((void *)a,(const void *)a_temp,n_valid*sizeof(double));
    }

    /* Cleanup */
//     mxDestroyArray(temp);
    
    return;
    
}
