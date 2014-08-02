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


export uniform double dotprod_ispc(uniform double a[], uniform double b[], uniform int n)
{
  double s = 0;
  uniform int n2 = n - (n % programCount);
  for (uniform int i=0; i<n2; i+=programCount)
    s += a[i+programIndex]*b[i+programIndex];

  uniform double sum=reduce_add(s);
  for (uniform int i=n2; i<n; ++i)
    sum+=a[i]*b[i];
  return sum;
}



export uniform double dotprod_ispc(uniform double a[], uniform double b[], uniform int64 astart, uniform int64 bstart, uniform int n)
{
  double s = 0;
  uniform int n2 = n - (n % programCount);
  for (uniform int i=0; i<n2; i+=programCount)
    s += a[i+astart+programIndex]*b[i+bstart+programIndex];

  uniform double sum=reduce_add(s);
  for (uniform int i=n2; i<n; ++i)
    sum+=a[i+astart]*b[i+bstart];
  return sum;
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
/*
  for (j=0; j<n2; j+=programCount) {
      for (i=0; i<m; ++i) {
        i_n = i*n;
        Ax[j+programIndex] += A[i_n+j+programIndex] * x[i];
      }
  }
*/
  for (i=0; i<m; ++i) {
        i_n = i*n;
    for (j=0; j<n2; j+=programCount) {
        Ax[j+programIndex] += A[i_n+j+programIndex] * x[i];
      }
  }


  for (j=0; j<n2; j+=programCount) {
    y[j+programIndex] = alpha*Ax[j+programIndex];
  }

  for (j=n2; j<n; ++j) {
      y[j]=0;
      for (i=0; i<m; ++i) {
        i_n = i*n;
        y[j] += alpha * A[i_n+j] * x[i];
      }
  }

/*
  for (j=0; j<n; ++j) {
    y[j] = alpha*Ax[j];
  }
*/

}

export void backsubst_L_ispc(uniform double L[], uniform double b[], uniform double x[], uniform int64 n, uniform int64 k)
{
  uniform int64 i, j;
  uniform double rhs;

  for (i=0; i<k; ++i) {
    rhs = b[i];
    uniform int64 i2=i-(i % programCount);
    double s=0;
    for (j=0; j<i2; j+=programCount) {
      s += L[(j+programIndex)*n+i]*x[j+programIndex];
    }
    rhs -= reduce_add(s);
    for (j=i2; j<i; ++j) {
      rhs -= L[j*n+i]*x[j];
    }
    x[i] = rhs/L[i*n+i];
  }
}

export void backsubst_Lt_ispc(uniform double L[], uniform double b[], uniform double x[], uniform int64 n, uniform int64 k)
{

  uniform int64 i, j;
  uniform double rhs;

  for (i=k; i>=1; --i) {
    rhs = b[i-1];
    uniform int64 k2=(k-i)-((k-i) % programCount)+i;
    double s=0;
    for (j=i; j<k2; j+=programCount) {
      s += L[(i-1)*n+j+programIndex]*x[j+programIndex];
    }
    rhs -= reduce_add(s);
    for (j=k2; j<k; ++j) {
      rhs -= L[(i-1)*n+j]*x[j];
    }
    x[i-1] = rhs/L[(i-1)*n+i-1];
  }
}




export void cholsolve_L_ispc(uniform double A[], uniform double b[], uniform double x[], uniform int64 n, uniform int64 k, uniform double tmp[])
{
    backsubst_L_ispc(A, b, tmp, n, k);
    backsubst_Lt_ispc(A, tmp, x, n, k);
}




