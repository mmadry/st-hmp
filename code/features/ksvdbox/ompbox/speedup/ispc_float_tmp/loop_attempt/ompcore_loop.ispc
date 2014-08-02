/**************************************************************************
 *
 * File name: ompcore.c
 *
 * Ron Rubinstein
 * Computer Science Department
 * Technion, Haifa 32000 Israel
 * ronrubin@cs
 *
 * Last Updated: 25.8.2009
 *
 *************************************************************************/

#include "myblas.ispc"

const int sizeof_double=8;

void memcpy(uniform double t[], uniform double s[], int tstart, int sstart, int n)
{
  for(int i=0; i<n; i++)
    t[i+tstart]=s[i+sstart];
  return;
}



export void ompcore_loop( 
   uniform double D[],
   uniform double G[],
   uniform double x[],
   uniform double alpha[],
   uniform double r[],
   uniform double Lchol[],
   uniform double c[],
   uniform double Gsub[],
   uniform double Dsub[],
   uniform double tempvec1[],
   uniform double tempvec2[],
   uniform double tmp_n[],
   uniform double tmp_m[],
   uniform double DtX[],
   uniform double XtX[],
   uniform int selected_atoms[],
   uniform int64 ind[],
   uniform double gammaPr[],
   uniform int T, 
   uniform int n, 
   uniform int m, 
   uniform int L, 
   uniform int DtX_specified, 
   uniform int XtX_specified,
   uniform int allocated_coefs,
   uniform int allocated_cols,
   uniform int batchomp,
   uniform int standardomp,
   uniform int erroromp
)


{  

  // local variables 
  double eps2, resnorm, delta, deltaprev, secs_remain;
  int  i, j, pos;
  double sum;
 
  /**********************   perform omp for each signal   **********************/
  
  int Lm=-(int)(-L/programCount)*programCount; 
  
  for (uniform int signum_c=0; signum_c<Lm; signum_c+=programCount) {
   
    int signum=signum_c+programIndex; 
 
    if (signum>=L) continue;
   
    /* initialize residual norm and deltaprev for error-omp */
    
    if (erroromp) {
      if (XtX_specified) {
        resnorm = XtX[signum];
      }
      else {
        resnorm = dotprod(x, x, n*signum, n*signum, n);
        //addproftime(&pd, XtX_TIME);
      }
      deltaprev = 0;     /* delta tracks the value of gamma'*G*gamma */
    }
    else {
      /* ignore residual norm stopping criterion */
      eps2 = 0;
      resnorm = 1;
    }
    
    
    if (resnorm>eps2 && T>0) {
      
      /* compute DtX */
      
      if (!DtX_specified) {
        //matT_vec(1, D, x+n*signum, DtX, n, m);
        matT_vec(1, D, x, DtX, n*signum, n, m);
        //addproftime(&pd, DtX_TIME);
      }
      
      
      /* initialize alpha := DtX */
      
      //memcpy(alpha, DtX + m*signum*DtX_specified, m*sizeof_double));
      memcpy(alpha, DtX, 0, m*signum*DtX_specified, m);
      
      
      /* mark all atoms as unselected */
      
      for (i=0; i<m; ++i) {
        selected_atoms[i] = 0;
      }
      
    }
    

    /* main loop */
    
    i=0;
    while (resnorm>eps2 && i<T) {

      /* index of next atom */
      
      pos = maxabs(alpha, m);
      //addproftime(&pd, MAXABS_TIME);
      
      
      /* stop criterion: selected same atom twice, or inner product too small */
      
      if (selected_atoms[pos] || alpha[pos]*alpha[pos]<1e-14) {
        break;
      }
      
      
      /* mark selected atom */
      
      ind[i] = pos;
      selected_atoms[pos] = 1;
      
      
      /* matrix reallocation */
      
      if (erroromp && i>=allocated_cols) {
      
        print("memory realloc no supported.\n"); 
        return;

        //allocated_cols = (int)(ceil(allocated_cols*MAT_INC_FACTOR) + 1.01);
        //Lchol = (double*)realloc(Lchol,n*allocated_cols*sizeof_double));
        //batchomp ? (Gsub = (double*)realloc(Gsub,m*allocated_cols*sizeof_double))) :
        //           (Dsub = (double*)realloc(Dsub,n*allocated_cols*sizeof_double))) ;
      }
      
      
      /* append column to Gsub or Dsub */
      
      if (batchomp) {
        //memcpy(Gsub+i*m, G+pos*m, m*sizeof_double));
        memcpy(Gsub, G, i*m, pos*m, m);
      }
      else {
        //memcpy(Dsub+i*n, D+pos*n, n*sizeof_double));
        memcpy(Dsub,D, i*n, pos*n, n);
      }
      
      
      /*** Cholesky update ***/
      
      if (i==0) {
        Lchol[0] = 1;
      }
      else {
        
        /* incremental Cholesky decomposition: compute next row of Lchol */
        
        if (standardomp) {
          //matT_vec(1, Dsub, D+n*pos, tempvec1, n, i);      /* compute tempvec1 := Dsub'*d where d is new atom */
          matT_vec(1, Dsub, D, tempvec1, n*pos, n, i);      /* compute tempvec1 := Dsub'*d where d is new atom */
          //addproftime(&pd, DtD_TIME);
        }
        else {
          //vec_assign(tempvec1, Gsub+i*m, ind, i);          /* extract tempvec1 := Gsub(ind,i) */
          vec_assign(tempvec1, Gsub, ind, i*m, i);          /* extract tempvec1 := Gsub(ind,i) */
        }
        backsubst(76, Lchol, tempvec1, tempvec2, n, i);   /* compute tempvec2 = Lchol \ tempvec1 */
        for (j=0; j<i; ++j) {                              /* write tempvec2 to end of Lchol */
          Lchol[j*n+i] = tempvec2[j];
        }
        
        /* compute Lchol(i,i) */
        sum = 0;
        for (j=0; j<i; ++j) {         /* compute sum of squares of last row without Lchol(i,i) */
          sum += SQR(Lchol[j*n+i]);
        }
        if ( (1-sum) <= 1e-14 ) {     /* Lchol(i,i) is zero => selected atoms are dependent */
          break;
        }
        Lchol[i*n+i] = sqrt(1-sum);
      }
      
      //addproftime(&pd, LCHOL_TIME);

      i++;
      
      
      /* perform orthogonal projection and compute sparse coefficients */
      
      //vec_assign(tempvec1, DtX + m*signum*DtX_specified, ind, i);   /* extract tempvec1 = DtX(ind) */
      vec_assign(tempvec1, DtX, ind, m*signum*DtX_specified, i);   /* extract tempvec1 = DtX(ind) */
int8 char_l=76;
      cholsolve( char_l, Lchol, tempvec1, tmp, c, n, i);                     /* solve LL'c = tempvec1 for c */
      //addproftime(&pd, COMPCOEF_TIME);
      

      /* update alpha = D'*residual */
      
      if (standardomp) {
        mat_vec(-1, Dsub, c, r, n, i, tmp_n);             /* compute r := -Dsub*c */
        vec_sum(1, x+n*signum, r, n);              /* compute r := x+r */
        
        //addproftime(&pd, COMPRES_TIME);
        matT_vec(1, D, r, alpha, n, m);            /* compute alpha := D'*r */
        //addproftime(&pd, DtR_TIME);
        
        /* update residual norm */
        if (erroromp) {
          resnorm = dotprod(r, r, n);
          //addproftime(&pd, UPDATE_RESNORM_TIME);
        }
      }
      else {
        mat_vec(1, Gsub, c, tempvec1, m, i);                              /* compute tempvec1 := Gsub*c */
        //memcpy(alpha, DtX + m*signum*DtX_specified, m*sizeof_double));    /* set alpha = D'*x */
        memcpy(alpha, DtX, 0, m*signum*DtX_specified, m);    /* set alpha = D'*x */
        vec_sum(-1, tempvec1, alpha, m);                                  /* compute alpha := alpha - tempvec1 */
        //addproftime(&pd, UPDATE_DtR_TIME);
        
        /* update residual norm */
        if (erroromp) {
          vec_assign(tempvec2, tempvec1, ind, i);      /* assign tempvec2 := tempvec1(ind) */
          delta = dotprod(c,tempvec2,i);               /* compute c'*tempvec2 */
          resnorm = resnorm - delta + deltaprev;       /* residual norm update */
          deltaprev = delta;
          //addproftime(&pd, UPDATE_RESNORM_TIME);
        }
      }
    }
    
    
    /*** generate output vector gamma ***/

    if (gamma_mode == FULL_GAMMA) {    /* write the coefs in c to their correct positions in gamma */
      for (j=0; j<i; ++j) {
        gammaPr[m*signum + ind[j]] = c[j];
      }
    }
    else {

      print("sparse matrix mode not supported in ispc.\n");
      return;
    }
    
  /* end omp */
  
  
//  /* free memory */
//  
//  if (!DtX_specified) {
//    free(DtX);
//  }
//  if (standardomp) {
//    free(r);
//    free(Dsub);
//  }
//  else {
//    free(Gsub);
//  }  
//  free(tempvec2);
//  free(tempvec1);
//  free(Lchol);
//  free(c);
//  free(selected_atoms);
//  free(ind);
//  free(alpha);
  
  return;
}
