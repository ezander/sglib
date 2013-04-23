% $Id: piter_n.m,v 1.1 2013/01/26 19:08:51 hgm Exp $
%
% The Log entries are at the end of the file.
%

%% texfile{
%%  AUTHOR    = "$Author: hgm $",
%%  VERSION   = "$Revision: 1.1 $",
%%  DATE      = "$Date: 2013/01/26 19:08:51 $",
%%  FILENAME  = "$RCSfile: piter_n.m,v $"}
%
%

% 
% Solve Au + (2+p_1) |u|^2 u = (fg + p_2) f
%
 
clc;
clear;
fg = 25;
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
R=1/100;
% conductivity of resistors on edges
D= diag((1/R)*ones(1,n));
As=B'*D*B;
% As should be singular
% eig(As);
% grounding of node "m"
A = As(1:m, 1:m);
% lam=eig(A);
% "cond(A) = ", lam(m)/lam(1)

% the rhs
f0 = zeros(m,1); f0(1) = 1;

% random starting value
u = rand(m,1);

p1 = 2*rand(1)-1;  p2 = 2*rand(1)-1;
%f = p2*f0;


% iteration  --- Cholesky factorisation
U = chol(A);
% inverse from Cholesky factors
%H = chol2inv(U);

H=U^(-1)*((U^(-1)))';

% initial values
km = 10;  k = 1;
acr = 1000*eps; acc = 1 + acr;

while ((k < km) & (acc > acr)),
  du = residual([p1, p2], H, A, fg, f0, u);
  u = u + du;
  acc = norm(du)/norm(u);
  k = k+1;
end

[k, p1, p2]
u'


% The Log entries
%
% $Log: piter_n.m,v $
% Revision 1.1  2013/01/26 19:08:51  hgm
% Initial revision as obtained from Dishi
%
% 
% 
%

