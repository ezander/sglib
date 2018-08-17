function dpp=ppder( pp )
% PPDER Computes the derivatives of a hole vector of polynomials.

dpp = pp;
n=size(pp.coefs,2);
%M=spdiags((n:-1:1)',1,n,n);
M=spdiags((n-1:-1:1)',0,n,n-1);
dpp.coefs=pp.coefs*M;
dpp.order=pp.order-1;