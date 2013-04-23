function [A, AI,m ] = setup_matrix_for_elec_network( R )
%UNTITLED14 Summary of this function goes here
%   Detailed explanation goes here

% edge - node incidence matrix
B=[0  1  0 -1  0  0;
   1  0  0  0 -1  0; 
   0  0  0 -1  1  0; 
   0  0 -1  1  0  0; 
   1  0 -1  0  0  0;  
   0 -1  1  0  0  0;
  -1  1  0  0  0  0; 
   0  0  1  0 -1  0;
   0  0  0  0  1 -1];
n=size(B,1);
% size of final matrix will be m:
m=size(B,2)-1;
% R=1/100;
% conductivity of resistors on edges
D= diag((1/R)*ones(1,n));
As=B'*D*B;
% As should be singular
% eig(As);
% grounding of node "m"
A = As(1:m, 1:m);
% lam=eig(A);
% "cond(A) = ", lam(m)/lam(1)
 

% iteration  --- Cholesky factorisation
U = chol(A);
% inverse from Cholesky factors
%H = chol2inv(U);

% my naive inverse by using cholesky
UI=inv(U);
AI=UI*UI';

end

