/**************************************************************************
 *
 * File name: myblas.c
 *
 * Ron Rubinstein
 * Computer Science Department
 * Technion, Haifa 32000 Israel
 * ronrubin@cs
 *
 * Version: 1.1
 * Last updated: 13.8.2009
 *
 *************************************************************************/


/* dot product */
/*   probably not much faster  */

export void dotprod_ispc(uniform double a[], uniform double b[], uniform int n, uniform reference double sum)
{
  //double sum = 0;
  uniform int64 i;
  for (i=0; i<n; ++i)
    sum += a[i]*b[i];
  return;
}

/* compute y := alpha*A'*x */

export void matT_vec_ispc(uniform const double alpha, uniform double A[], uniform double x[], uniform double y[], uniform const int64 n, uniform const int64 m)
{
  uniform int64 i,j;
  int64 n_i;
  uniform int64 n_i_2;

  for (j=0; j<m; ++j) {
    y[j] = 0;
  }

  /* use loop unrolling to accelerate computation */

  /*
  for (i=0; i<m; ++i) {
    n_i = n*i;
    sum0 = sum1 = sum2 = sum3 = 0;
    for (j=0; j+4<n; j+=4) {
      sum0 += A[n_i+j]*x[j];
      sum1 += A[n_i+j+1]*x[j+1];
      sum2 += A[n_i+j+2]*x[j+2];
      sum3 += A[n_i+j+3]*x[j+3];
    }
    y[i] += alpha * ((sum0 + sum1) + (sum2 + sum3));
    while (j<n) {
      y[i] += alpha*A[n_i+j]*x[j];
      j++;
    }
  }
  */

  /* use ispc to speed up computation */

  uniform int64 m2 = m - (m % programCount);
  for (i=0; i<m2; i+=programCount) {
      n_i = n*(i+programIndex);
      for(j=0; j<n; ++j) {
        y[i+programIndex] += A[n_i+j] * x[j];
      }
  }

  for (i=m2; i<m; ++i) {
      n_i_2 = n*i;
      for(j=0; j<n; ++j) {
        y[i] += A[n_i_2+j] * x[j];
      }
  }

  for (i=0; i<m; ++i)
    y[i]*=alpha;

}


/* compute y := alpha*A*x */

export void mat_vec_ispc(uniform double alpha, uniform double A[], uniform double x[], uniform double y[], uniform const int64 n, uniform const int64 m, uniform double Ax[])
{
  uniform int64 i, j;
  uniform int64 i_n;

  for(j=0; j<n; ++j)
    Ax[j]=0;

  uniform int n2 = n - (n % programCount);
  for (j=0; j<n2; j+=programCount) {
      for (i=0; i<m; ++i) {
        i_n = i*n;
        Ax[j+programIndex] += A[i_n+j+programIndex] * x[i];
      }
  }
  for (j=n2; j<n; ++j) {
      for (i=0; i<m; ++i) {
        i_n = i*n;
        Ax[j] += A[i_n+j] * x[i];
      }
  }

  for (j=0; j<n; ++j) {
    y[j] = alpha*Ax[j];
  }

/*  for (j=0; j<n; j+=programCount) {
    y[j+programIndex] = alpha*Ax[j+programIndex];
  }*/

}

/*
void mat_vec(double alpha, double A[], double x[], double y[], mwSize n, mwSize m)
{
  mwIndex i, j, i_n;
  double *Ax;

  Ax = mxCalloc(n,sizeof(double));

  for (i=0; i<m; ++i) {
    i_n = i*n;
    for (j=0; j<n; ++j) {
      Ax[j] += A[i_n+j] * x[i];
    }
  }

  for (j=0; j<n; ++j) {
    y[j] = alpha*Ax[j];
  }

  mxFree(Ax);
}
*/




