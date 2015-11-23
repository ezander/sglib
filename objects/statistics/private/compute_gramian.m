function Q=compute_gramian(polysys, dist, N, tol)
% COMPUTE_GRAMIAN Short description of compute_gramian.
%   COMPUTE_GRAMIAN(VARARGIN) Long description of compute_gramian.
%
% Options
%
% References
%
% Notes
%
% Example (<a href="matlab:run_example compute_gramian">run</a>)
%
% See also

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

if nargin<2 || isempty(dist)
    dist = polysys.weighting_dist();
end
if nargin<3 || isempty(N)
    N = 4;
end
if nargin<4 || isempty(tol)
    tol = 1e-6;
end

dom=dist.invcdf([0,1]);
fun = @(x)( polysys.evaluate(N,x)'*polysys.evaluate(N,x)*dist.pdf(x));
Q = integral(fun, dom(1), dom(2), 'ArrayValued', true, 'RelTol', tol, 'AbsTol', tol);
