function [xmid, x]=linspace_midpoints( xmin, xmax, N )
% LINSPACE_MIDPOINTS Returns linearly spaced interval midpoints.
%   [XMID,X]=LINSPACE_MIDPOINTS( XMIN, XMAX, N ) splits the interval  XMIN
%   to XMAX into N equally spaced intervals and returns the midpoints of
%   those intervals in XMID. The endpoints of the intervals are returned in
%   X, which is the same as calling LINSPACE(XMIN, XMAX, N+1).
%
% Example (<a href="matlab:run_example linspace_midpoints">run</a>)
%     [xmid, x] = linspace_midpoints(0, pi, 15);
%     h = xmid(2)-xmid(1);
%     plot( xmid, cos(xmid), 'ro-', xmid, diff(sin(x))/h, 'bx-');
%     legend('sin''(x)', 'forward diff');
%
% See also LINSPACE

%   Elmar Zander
%   Copyright 2015, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

if nargin<3
    N=100;
end
x=linspace(xmin,xmax,N+1);
xmid=x(1:end-1)+(x(2)-x(1))/2;
