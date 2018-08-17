function dpp=ppint( pp, start )
% PPDER Computes the integral of a piecewise polynomial.

if nargin<2
    start = 0;
end

dpp = pp;
n=size(pp.coefs,2);
M=spdiags(1./(n:-1:0)',0,n,n+1);
dpp.coefs=pp.coefs*M;
dpp.order=pp.order+1;
dpp.coefs(1, end) = start;

% Correct constant term to make polynomial continuous
x2 = dpp.breaks(2:end-1);
x = x2-abs(x2).*eps;
assert(all(x<x2))
y = ppval(dpp, x);
dpp.coefs(2:end,end)=cumsum(y);
