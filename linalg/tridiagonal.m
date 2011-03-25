function M = tridiagonal( N, d, u, l )
% TRIDIAGONAL Tridiagonal matrix
%
%    M = tridiagonal( N, d, u, l ) creates a tridiagonalrix with N rows 
%    and columns. d is used as the diagonal value, u for values above and 
%    l for the values below the diagonal.

%    Copyright 2002 Elmar Zander, Institute for Scientific Computing, Braunschweig
%    $Id: tridiagonal.m 45 2008-11-26 15:40:16Z ezander $

M = zeros( N, N );
M(1:N+1:end)=d;
M(2:N+1:end)=l;
M(N+1:N+1:end)=u;
