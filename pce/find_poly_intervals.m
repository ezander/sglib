function r=find_poly_intervals(p, y)
% FIND_POLY_INTERVALS Short description of find_poly_intervals.
%   FIND_POLY_INTERVALS Long description of find_poly_intervals.
%
% Options
%
% References
%
% Notes
%
% Example (<a href="matlab:run_example find_poly_intervals">run</a>)
%
% See also

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

% erase double roots if present
ind = r(1:2:end)==r(2:2:end);
if any(ind)
    i=find(ind)*2;
    r([i, i-1])=[];
end
