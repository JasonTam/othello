/*=================================================================
 * The calling syntax is:
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

/* Input Arguments */
#define	B_IN	prhs[0]
#define	TOK_IN	prhs[1]

/* Output Arguments */
#define	NB_OUT	plhs[0]
#define	A_OUT	plhs[1]

static int dirIndN(int m, int n, int off){return m-off+L*n;}
static int dirIndS(int m, int n, int off){return m+off+L*n;}
static int dirIndW(int m, int n, int off){return m+L*(n-off);}
static int dirIndE(int m, int n, int off){return m+L*(n+off);}
static int dirIndNW(int m, int n, int off){return m-off+L*(n-off);}
static int dirIndSE(int m, int n, int off){return m+off+L*(n+off);}
static int dirIndNE(int m, int n, int off){return m-off+L*(n+off);}
static int dirIndSW(int m, int n, int off){return m+off+L*(n-off);}

typedef int (*dirIndPtr)(int, int, int );
dirIndPtr N_Ptr = dirIndN;
dirIndPtr S_Ptr = dirIndS;
dirIndPtr W_Ptr = dirIndW;
dirIndPtr E_Ptr = dirIndE;
dirIndPtr NW_Ptr = dirIndNW;
dirIndPtr SE_Ptr = dirIndSE;
dirIndPtr NE_Ptr = dirIndNE;
dirIndPtr SW_Ptr = dirIndSW;


static int rayFlip( double b[], int m, int n, double tok,
        double potB[], int (*dirIndPtr)(int, int, int)) {
    int off = 1;
    int valid = 0;
    while ((m-off>=0)&&(n-off>=0)&&(m+off<L)&&(n+off<L)&&
            (b[(*dirIndPtr)(m,n,off)]==(-tok))) {
        off++;
    }
    if ((b[(*dirIndPtr)(m,n,off)]==tok)&&(off>1)) {
        for (;off>0;off--) {potB[(*dirIndPtr)(m,n,off)]=tok;}
        valid = 1;
    }
    return valid;
}
    

static int isValid( double	b[], int m, int n, double tok,
        double potB[] ) {
    int valid = 0;
    int off;

    valid += rayFlip( b, m, n, tok, potB, N_Ptr);
    valid += rayFlip( b, m, n, tok, potB, S_Ptr);
    valid += rayFlip( b, m, n, tok, potB, W_Ptr);
    valid += rayFlip( b, m, n, tok, potB, E_Ptr);
    valid += rayFlip( b, m, n, tok, potB, NW_Ptr);
    valid += rayFlip( b, m, n, tok, potB, SE_Ptr);
    valid += rayFlip( b, m, n, tok, potB, NE_Ptr);
    valid += rayFlip( b, m, n, tok, potB, SW_Ptr);

    potB[m+L*n]=tok;    // Place the actual move down
    
    return valid;
}

static int getAllValid( double	nb[], double a[],
           double b[], double *tok ) {
    int i, m, n, c;     // index, row, col, tempiter, count    
    c = 0;
    for ( n = 0; n < L; n++) {
        for ( m = 0; m < L; m++) {
            i = m+L*n;
            if (b[i]==0) {
                double potB[L*L];
                memcpy(potB,b,sizeof(potB));
                if (isValid(b,m,n,*tok,potB)>0) {
                    a[c] = i+1;     // add the 1 for matlab indexing here
                    memcpy(nb+(c++)*L*L,potB,sizeof(potB));
                }
            }
        }
    }
    return c;
}


void mexFunction( int nlhs, mxArray *plhs[],    /* Input Vars */
		  int nrhs, const mxArray*prhs[] )      /* Output Vars */
{ 
    double *nb,*a; 
    double *b,*tok; 
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
    m = mxGetM(B_IN);   /* Sould be L */
    n = mxGetN(B_IN);   /* Sould be L */
    if (!mxIsDouble(B_IN) || mxIsComplex(B_IN) || 
	(m != L) || (n != L)) { 
	    mexErrMsgIdAndTxt( "MATLAB:getAllValid:invalid board",
                "getAllValid requires that Y be a L x L matrix."); 
    } 

    /* Assign pointers to the input parameters */ 
    b = mxGetPr(B_IN); 
    tok = mxGetPr(TOK_IN);

    /* Do the actual computations in a subroutine */
    int n_valid;
    double nb_temp[L*L*L*L];
    double a_temp[L*L];
    n_valid = getAllValid(nb_temp,a_temp,b,tok);
    
    /* Create a matrix for the return argument */ 
    const mwSize dims[]={L,L,n_valid};
    NB_OUT = mxCreateNumericArray( NB_DIMS, dims, mxDOUBLE_CLASS, mxREAL);
    A_OUT = mxCreateDoubleMatrix( n_valid, 1, mxREAL); 

    /* Assign pointers to the output parameters */ 
    nb = mxGetPr(NB_OUT);
    a = mxGetPr(A_OUT);
    
    if (n_valid>0) {
        memcpy(nb,nb_temp,n_valid*L*L*sizeof(double));
        memcpy(a,a_temp,n_valid*sizeof(double));
    }

    return;
    
}
