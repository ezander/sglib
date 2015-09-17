function r=find_poly_intervals(p, y)
% FIND_POLY_INTERVALS Finds intervals in which a polynomials inequality is satisfied.
%   R=FIND_POLY_INTERVALS(P, Y) finds intervals R in which the polynomial
%   inequality P(X)<Y is satisfied for all X in R. Also intervals with
%   bounds at positive and negative infinity are returned. R contains the
%   lower bounds in R(1,:) and the upper bounds of the intervals in R(2,:).
%   This functions is used for the computation of the PDF and CDF of the
%   univariate GPCs.
%
% Example (<a href="matlab:run_example find_poly_intervals">run</a>)
%   p=1e3*poly(cos(pi*(0.5:11.5)/12)); % chebyshev
%   y=0.3;
%   r=find_poly_intervals(p,y);
%   x=linspace(-1.5,1.5,1000);
%   plot(x,polyval(p,x), x, y*ones(size(x))); grid on;
%   line(r,y*ones(size(r)),'Color', 'r'); % show intervals
%   ylim([-0.6, 1.2])
%
% See also GPC_PDF_1D, GPC_CDF_1D, POLY, POLYVAL, ROOTS

%   Elmar Zander
%   Copyright 2014, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

q=p;
q(end)=q(end)-y;
r=roots( q );
r=sort(r(imag(r)==0));
r=r(:)';

deg=length(p)-1;

sign_inf=sign(p(1));
if sign_inf<0
    r=[r, inf];
end

if mod(deg,2)==0
    sign_minf=sign_inf;
else
    sign_minf=-sign_inf;
end
if sign_minf<0
    r=[-inf, r];
end

r=reshape(r, 2, []);

% erase double roots if present
ind = r(1,:)==r(2,:);
if any(ind)
    r(:,ind)=[];
end
