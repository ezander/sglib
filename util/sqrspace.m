function y = sqrspace( d1, d2, n )
% SQRSPACE2 Square-spaced vector
%   y = SQRSPACE(d1, d2) generates a row vector of 100 points between d1 
%   and d2, where the spacing increases as the square of x.
%
%   SQRSPACE(d1, d2, N) generates N points.
%
%   See also LINSPACE, LOGSPACE2

%    Copyright 2002 Elmar Zander, Institute of Scientific Computing, Braunschweig
%    $Id: logspace2.m 45 2008-11-26 15:40:16Z ezander $

if nargin==2
    n=100;
end

y=(linspace(sqrt(d1),sqrt(d2),n) ).^2;
