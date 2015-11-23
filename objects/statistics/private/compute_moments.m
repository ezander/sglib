function m=compute_moments(dist, tol)
% COMPUTE_MOMENTS Short description of compute_moments.
%   COMPUTE_MOMENTS(VARARGIN) Long description of compute_moments.
%
% Options
%
% References
%
% Notes
%
% Example (<a href="matlab:run_example compute_moments">run</a>)
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

if nargin<2 || isempty(tol)
    tol = 1e-6;
end

dom=dist.invcdf([0,1]);

% 0th moment: should be one
fun = @(x)( 1*dist.pdf(x));
m0 = integral(fun, dom(1), dom(2), 'RelTol', tol, 'AbsTol', tol);

% 1st moment: the mean
fun = @(x)( x.*dist.pdf(x));
m1 = integral(fun, dom(1), dom(2), 'RelTol', tol, 'AbsTol', tol);

% 2nd central moment: the variance
fun = @(x)( (x-m1).^2.*dist.pdf(x));
m2 = integral(fun, dom(1), dom(2), 'RelTol', tol, 'AbsTol', tol);

% 3rd standardized moment: the skewness
fun = @(x)( ((x-m1)/sqrt(m2)).^3.*dist.pdf(x));
m3 = integral(fun, dom(1), dom(2), 'RelTol', tol, 'AbsTol', tol);

% 4th standardized moment: the kurtosis (where we subtract 3 to get the
% kurtosis excess)
fun = @(x)( ((x-m1)/sqrt(m2)).^4.*dist.pdf(x));
m4 = integral(fun, dom(1), dom(2), 'RelTol', tol, 'AbsTol', tol);
m4 = m4 - 3;

m = {m0, m1, m2, m3, m4};
