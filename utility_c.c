/*=================================================================
 * Jason Tam
 * October 2013
 * An attempt to make my Othello AI faster by using C
 * Syntax in MATLAB:
 *
 *		[ utilScore ] = utility( board, curTok )
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
#define	CTOK_IN	prhs[1]

/* Output Arguments */
#define	SCORE_OUT	plhs[0]

/* For debugging */
void DisplayMatrix(char *Name, double *Data, int M, int N) {
    mexPrintf("%s = \n", Name);
    int m,n;
    for(m = 0; m < M; m++, mexPrintf("\n"))
        for(n = 0; n < N; n++)
            mexPrintf("%f ", Data[m + M*n]);
}


/* Get all positions that cause flips */
static double utility( const mxArray*prhs[]) {
    double *b, *cTok;	/* Input Vars */
    b = mxGetPr(B_IN);
    cTok = mxGetPr(CTOK_IN);
    int i, iter=0;
    double score=0;
    double h_par=0, h_mob=0, h_cor=0;

    /* Move iteration */
    /* Score */
    for (i=0; i<L*L; i++) {
        iter += abs(b[i]);
        h_par += b[i]; 
    }
    h_par /= (*cTok)*iter;
    
    /* Mobility */
    mxArray *lhs_gAV[2]; 
    mexCallMATLAB(2, lhs_gAV, 2, (mxArray**)prhs, "getAllValid");
    int aMax = mxGetM(lhs_gAV[1]);
    
    mxArray *rhs_temp[2];
    rhs_temp[0] = ( mxArray*)prhs[0];
    rhs_temp[1] = mxCreateDoubleScalar(-*cTok);
    
    mexCallMATLAB(2, lhs_gAV, 2, rhs_temp, "getAllValid");
    int aMin = mxGetM(lhs_gAV[1]);
    /* mxDestroyArray(rhs_temp); */
    h_mob = ((double)aMax-aMin)/(aMax+aMin);
    
    /* Corners */
    int corners[4];
    corners[0] = b[0];
    corners[1] = b[(L-1)];
    corners[2] = b[L*(L-1)];
    corners[3] = b[L*L-1];
    
    int temp_c=0;
    for (i=0; i<4; i++) {
        h_cor += corners[i];
        temp_c += abs(corners[i]);
    }
    if (temp_c)
        h_cor /= (*cTok)*temp_c;
    else
        h_cor = 0;
    
/*        
//             % Stability
//             h_s = 0;
*/        
    
    
    /* Weights */
    int w[4];
    w[0] = 10+5000*((L*L-iter)<6);
    w[1] = 50;
    w[2] = 800;
    
    /* Calculate Total Score (Dot prod) */
    score = w[0]*h_par+
            w[1]*h_mob+
            w[2]*h_cor;
    
    return score;
}

/* Gateway Function */
void mexFunction( int nlhs, mxArray *plhs[],    /* Input Vars */
		  int nrhs, const mxArray*prhs[] )      /* Output Vars */
{ 
    double *score;      /* Output Vars */
/*     double *b, *cTok;	/* Input Vars */
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
    m = mxGetM(B_IN);	/* Should be L */
    n = mxGetN(B_IN);	/* Should be L */
    if (!mxIsDouble(B_IN) || mxIsComplex(B_IN) || 
	(m != L) || (n != L)) { 
	    mexErrMsgIdAndTxt( "MATLAB:getAllValid:invalid board",
                "getAllValid requires that B be a L x L matrix."); 
    } 
    
    /* Do the actual computations in a subroutine and assign */
    SCORE_OUT = mxCreateDoubleScalar(utility(prhs));

    /* Assign pointers to the output parameters */ 
    score = mxGetPr(SCORE_OUT);
    
    /* Cleanup */
/* mxDestroyArray(temp); */
    
    return;
    
}
