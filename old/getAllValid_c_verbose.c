/*=================================================================
 * Jason Tam
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

typedef int (*dirIndPtr)(int, int, int );
dirIndPtr N_Ptr = dirIndN;
dirIndPtr S_Ptr = dirIndN;
dirIndPtr W_Ptr = dirIndN;
dirIndPtr E_Ptr = dirIndN;

static int rayFlip( double b[], int m, int n, double tok,
        double potB[], int (*dirIndPtr)(int, int, int)) {
    int off = 1;
    int valid;
    while ((m-off>=0)&&(n-off>=0)&&(m+off<L)&&(n-off>=0)&&
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
  
//     mexPrintf("-------------%d|%d-----------------------------\n",m,n);
    
    
    int off;
//     Vertical
    //     Up
    
    
//     mexPrintf("-------------UP----------------------\n");
    off = 1;
    while ((m-off>=0)&&
            (b[(m-off)+L*n]==(-tok))) {
//         mexPrintf("%d | %d | %g\n",
//                 (m-off)+L*n,off,b[(m-off)+L*n]);
        off++;
    }
    if ((b[(m-off)+L*n]==tok)&&(off>1)) {
        for (;off>0;off--) {potB[(m-off)+L*n]=tok;}
        valid = 1;
    }
    
    
    //     Down
//     mexPrintf("-------------DOWN----------------------\n");
    off = 1;
    while ((m+off<L)&&
            (b[(m+off)+L*n]==(-tok))) {
//         mexPrintf("%d | %d | %g\n",
//                 (m+off)+L*n,off,b[(m+off)+L*n]);
        off++;
    }
    if ((b[(m+off)+L*n]==tok)&&(off>1)) {
        for (;off>0;off--) {potB[(m+off)+L*n]=tok;}
        valid = 1;
    }
    
//     Horizontal
    //     Left
//     mexPrintf("-------------LEFT----------------------\n");
    off = 1;
    while ((n-off>=0)&&
            (b[m+L*(n-off)]==(-tok))) {
//         mexPrintf("%d | %d | %g\n",
//                 m+L*(n-off),off,b[m+L*(n-off)]);
        off++;
    }
    if ((b[m+L*(n-off)]==tok)&&(off>1)) {
        for (;off>0;off--) {potB[m+L*(n-off)]=tok;}
        valid = 1;
    }
    
    
    //     Right
//     mexPrintf("-------------RIGHT----------------------\n");
    off = 1;
    while ((n+off<L)&&
            (b[m+L*(n+off)]==(-tok))) {
//         mexPrintf("%d | %d | %g\n",
//                 m+L*(n+off),off,b[m+L*(n+off)]);
        off++;
    }
    if ((b[m+L*(n+off)]==tok)&&(off>1)) {
        for (;off>0;off--) {potB[m+L*(n+off)]=tok;}
        valid = 1;
    }
    
//     Diagonal
    
    //     NW
//     mexPrintf("-------------NW----------------------\n");
    off = 1;
    while ((m-off>=0)&&(n-off>=0)&&
            (b[(m-off)+L*(n-off)]==(-tok))) {
//         mexPrintf("%d | %d | %g\n",
//                 (m-off)+L*(n-off),off,b[(m-off)+L*(n-off)]);
        off++;
    }
    if ((b[(m-off)+L*(n-off)]==tok)&&(off>1)) {
        for (;off>0;off--) {potB[(m-off)+L*(n-off)]=tok;}
        valid = 1;
    }
    
    //     SE
//     mexPrintf("-------------SE----------------------\n");
    off = 1;
    while ((m+off<L)&&(n+off<L)&&
            (b[(m+off)+L*(n+off)]==(-tok))) {
//         mexPrintf("%d | %d | %g\n",
//                 (m+off)+L*(n+off),off,b[(m+off)+L*(n+off)]);
        off++;
    }
    if ((b[(m+off)+L*(n+off)]==tok)&&(off>1)) {
        for (;off>0;off--) {potB[(m+off)+L*(n+off)]=tok;}
        valid = 1;
    }
    
    //     NE
//     mexPrintf("-------------NE----------------------\n");
    off = 1;
    while ((m-off>=0)&&(n+off<L)&&
            (b[(m-off)+L*(n+off)]==(-tok))) {
//         mexPrintf("%d | %d | %g\n",
//                 (m-off)+L*(n+off),off,b[(m-off)+L*(n+off)]);
        off++;
    }
    if ((b[(m-off)+L*(n+off)]==tok)&&(off>1)) {
        for (;off>0;off--) {potB[(m-off)+L*(n+off)]=tok;}
        valid = 1;
    }
    
    //     SW
//     mexPrintf("-------------SW----------------------\n");
    off = 1;
    while ((m+off<L)&&(n-off>=0)&&
            (b[(m+off)+L*(n-off)]==(-tok))) {
//         mexPrintf("%d | %d | %g\n",
//                 (m+off)+L*(n-off),off,b[(m+off)+L*(n-off)]);
        off++;
    }
    if ((b[(m+off)+L*(n-off)]==tok)&&(off>1)) {
        for (;off>0;off--) {potB[(m+off)+L*(n-off)]=tok;}
        valid = 1;
    }
    
//     Place the actual move down
    potB[m+L*n]=tok;
    
    return valid;
}

static void getAllValid( double	nb[], double a[],
           double b[], double *tok ) {
    int i, m, n, q;    
    
    for ( n = 0; n < L; n++) {
        for ( m = 0; m < L; m++) {
            i = m+L*n;
            if (b[i]==0) {
                double potB[L*L];
                //     I cant get memcpy to work....gameover
                //     memcpy(potB,b,sizeof(b));
                for ( q = 0; q < L*L; q++) { potB[q] = b[q];}
                
                if (isValid(b,m,n,*tok,potB)) {
                    a[i] = i+1;
//                     add the 1 for matlab indexing here
//                     so we can eliminate 0's
//                     +L*L  per slice
                    memcpy(nb+i*L*L,potB,sizeof(potB));
                    
                }
            }
        }
    }

    return;
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

    /* Create a matrix for the return argument */ 
    const mwSize dims[]={L,L,L*L};
    NB_OUT = mxCreateNumericArray( NB_DIMS, dims, mxDOUBLE_CLASS, mxREAL);
    A_OUT = mxCreateDoubleMatrix( L*L, 1, mxREAL); 

    /* Assign pointers to the various parameters */ 
    nb = mxGetPr(NB_OUT);
    a = mxGetPr(A_OUT);
    b = mxGetPr(B_IN); 
    tok = mxGetPr(TOK_IN);

    /* Do the actual computations in a subroutine */
    getAllValid(nb,a,b,tok);
    return;
    
}
