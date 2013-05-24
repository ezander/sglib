function y = sqrspace( d1, d2, n, p )
% SQRSPACE2 Square-spaced vector
%   y = SQRSPACE(d1, d2) generates a row vector of 100 points between d1 
%   and d2, where the spacing increases with the square of x. The spacing
%   of SQRSPACE is, however, not as extreme as that of LOGSPACE or
%   LOGSPACE2, and has the further advantage that 0 can be one endpoint and
%   can even be crossed.
%
%   SQRSPACE(d1, d2, N) generates N points instead of the default 100
%   points. 
%
%   SQRSPACE(d1, d2, N, P) generates N points where the scaling is with
%   the P-th power instead of the default second power. Setting [] for N
%   uses the default N=100;
%
% Example (<a href="matlab:run_example sqrspace">run</a>)
%   clf
%   subplot(2,1,1)
%   N=30;
%   hold all
%   plot(linspace(1,100, N), 3*ones(1,N), 'bx');
%   plot(sqrspace(1,100, N), 2*ones(1,N), 'rx');
%   plot(logspace2(1,100, N), 1*ones(1,N), 'gx');
%   legend('linspace', 'sqrspace', 'logspace2');
%   ylim([0.5, 3.5]);
%   hold off
%
%   subplot(2,1,2)
%   hold all
%   plot(sqrspace(-100, 300, N, 1), 4*ones(1,N), 'bx');
%   plot(sqrspace(-100, 300, N, 2), 3*ones(1,N), 'rx');
%   plot(sqrspace(-100, 300, N, 4), 2*ones(1,N), 'gx');
%   plot(sqrspace(300, -100, N, 6), 1*ones(1,N), 'mx');
%   legend('p=1', 'p=2', 'p=4', 'p=6');
%   ylim([0.5, 4.5]);
%   hold off
%
% See also LINSPACE, LOGSPACE2

%    Copyright 2002 Elmar Zander, Institute of Scientific Computing, Braunschweig
%    $Id: logspace2.m 45 2008-11-26 15:40:16Z ezander $

if nargin<3 || isempty(n)
    n=100;
end
if nargin<4 || isempty(p)
    p=2;
end

sd1 = signed_power(d1, 1/p);
sd2 = signed_power(d2, 1/p);
y = signed_power(linspace(sd1,sd2,n), p);

function y=signed_power(x, p)
y = sign(x) .* abs(x).^p;
