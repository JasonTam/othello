/*=================================================================
 * Jason Tam
 * October 2013
 * An attempt to make my Othello AI faster by using C
 * Syntax in MATLAB:
 *
 *		[ nextBoards, actions] = getAllValid( b, tok )
 * NOTE, b AND tok HAVE TO BE OF THE CORRECT TYPE IN MATLAB
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
static char dirIndN (char m, char n, char off){return m-off+L*n;}
static char dirIndS (char m, char n, char off){return m+off+L*n;}
static char dirIndW (char m, char n, char off){return m+L*(n-off);}
static char dirIndE (char m, char n, char off){return m+L*(n+off);}
static char dirIndNW(char m, char n, char off){return m-off+L*(n-off);}
static char dirIndSE(char m, char n, char off){return m+off+L*(n+off);}
static char dirIndNE(char m, char n, char off){return m-off+L*(n+off);}
static char dirIndSW(char m, char n, char off){return m+off+L*(n-off);}

typedef char (*dirFnPtr)(char, char, char );
static dirFnPtr dirFnPtrArr[N_DIR] = {dirIndN,dirIndS,dirIndW,dirIndE,dirIndNW,dirIndSE,dirIndNE,dirIndSW};

/* Directional Boundary Index Checks */
static char bdryN (char m, char n, char off){return m-off>=0;}
static char bdryS (char m, char n, char off){return m+off<L;}
static char bdryW (char m, char n, char off){return n-off>=0;}
static char bdryE (char m, char n, char off){return n+off<L;}
static char bdryNW(char m, char n, char off){return (m-off>=0)&&(n-off>=0);}
static char bdrySE(char m, char n, char off){return (m+off<L)&&(n+off<L);}
static char bdryNE(char m, char n, char off){return (m-off>=0)&&(n+off<L);}
static char bdrySW(char m, char n, char off){return (m+off<L)&&(n-off>=0);}

typedef char (*bFnPtr)(char, char, char );
static bFnPtr bFnPtrArr[N_DIR] = {bdryN,bdryS,bdryW,bdryE,bdryNW,bdrySE,bdryNE,bdrySW};

/* Flips peices */
static char rayFlip( char b[], char m, char n, char tok,
        char potB[], char (*dirFnPtr)(char, char, char), char (*bFnPtr)(char, char, char)) {
    char off = 1;
    char valid = 0;
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
static char isValid( char	b[], char m, char n, char tok,
        char potB[] ) {
    char valid = 0;
    
    for (char di=0; di<N_DIR; di++) {
        valid += rayFlip( b, m, n, tok, potB, dirFnPtrArr[di], bFnPtrArr[di]);
    }
    
    return valid;
}

/* Get all positions that cause flips */
static char getAllValid( char	*nb, char *a,
           char b[], char tok, char *potB ) {
    char i=0, m=0, n=0, c=0;         // index, row, col, tempiter, count    
   
    for ( n = 0; n < L; n++) {
        for ( m = 0; m < L; m++) {
            i = m+L*n;
            if (b[i]==0) {          // Only analyze for empty spots
                char dila = 0;
                for (char di=0; di<N_DIR; di++)
                    dila += (b[dirFnPtrArr[di](m,n,1)]==(-tok))&&bFnPtrArr[di](m,n,1);
                if (dila) {     // Only analyze for spots touching enemies
                    // Copy potB = b (potB will be modified)
                    memcpy((void *)potB,(const void *)b,L*L*sizeof(char));             

                    if (isValid(b,m,n,tok,potB)>0) { // If it's a valid move
                        a[c] = i+1;     // add the 1 for matlab indexing here
                        // Copy over potential board to a slice of output
                        memcpy((void *)nb+(c++)*L*L*sizeof(char),(const void *)potB,L*L*sizeof(char));
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
    char *nb,*a;      /* Output Vars */
    char *b,*tok;     /* Input Vars */
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
//     m = mxGetM(B_IN);	// Should be L
//     n = mxGetN(B_IN);	// Should be L
//     if (!mxIschar8(B_IN) || mxIsComplex(B_IN) || 
// 	(m != L) || (n != L)) { 
// 	    mexErrMsgIdAndTxt( "MATLAB:getAllValid:invalid board",
//                 "getAllValid requires that Y be a L x L matrix."); 
//     } 

    /* Assign pocharers to the input parameters */ 
    b = (char *)mxGetData(B_IN); 
    tok = (char *)mxGetData(TOK_IN);

    /* Creating temp variables */ 
    char n_valid;
    char nb_temp[L*L*L*L];
    char a_temp[L*L];
    char potB[L*L];
    
    /* Do the actual computations in a subroutine */
    n_valid = getAllValid(nb_temp,a_temp,b,*tok,potB);
    
    /* Create a matrix for the return argument */ 
    const mwSize dims[]={L,L,n_valid};
    NB_OUT = mxCreateNumericArray( NB_DIMS, dims, mxINT8_CLASS, mxREAL);
    A_OUT = mxCreateNumericMatrix( n_valid, 1, mxINT8_CLASS, mxREAL);
            
    /* Assign pocharers to the output parameters */ 
    nb = (char *)mxGetData(NB_OUT);
    a = (char *)mxGetData(A_OUT);
    
    /* Copy over results from tmp variables to output */
    if (n_valid>0) {
        memcpy((void *)nb,(const void *)nb_temp,n_valid*L*L*sizeof(char));
        memcpy((void *)a,(const void *)a_temp,n_valid*sizeof(char));
    }

    /* Cleanup */
//     mxDestroyArray(temp);
    
    return;
    
}
