function y = sqrspace( d1, d2, n, p )
% SQRSPACE Square-spaced vector
%   Y = SQRSPACE(D1, D2) generates a row vector of 100 points between D1
%   and D2, where the spacing increases with the square of X. The spacing
%   of SQRSPACE is, however, not as extreme as that of LOGSPACE or
%   LOGSPACE2, and has the further advantage that 0 can be one endpoint and
%   can even be crossed.
%
%   SQRSPACE(D1, D2, N) generates N points instead of the default 100
%   points.
%
%   SQRSPACE(D1, D2, N, P) generates N points where the scaling is with
%   the P-th power instead of the default second power. Setting [] for N
%   uses the default N=100.
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
% See also LINSPACE, LOGSPACE2, POINT_RANGE

%   Elmar Zander
%   Copyright 2002, 2013, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


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
