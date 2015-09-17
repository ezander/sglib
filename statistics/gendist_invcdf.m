function x=gendist_invcdf(y, dist, varargin)
% GENDIST_INVCDF Inverse CDF (quantile function) of a gendist.
%   X=GENDIST_INVCDF( Y, DIST ) computes the inverse cumulative distribution
%   function of the probability distribution DIST values in Y, which should
%   all be in [0,1]. This function can be used to transform [0,1] uniformly
%   distributed random numbers into random numbers distributed according to
%   the probability distribution DIST. A further use is the computation of
%   quantiles of the distribution.
%
% Example 1 (<a href="matlab:run_example gendist_invcdf 1">run</a>)
%   % Compute min, max and median of a shifted Beta distribution
%   dist = gendist_create('beta', {2, 3}, 'shift', 3.8 );
%   fprintf('bounds: [%g, %g]\n', gendist_invcdf([0, 1], dist));
%   fprintf('median: [%g]\n', gendist_invcdf(0.5, dist));
%
% Example 2 (<a href="matlab:run_example gendist_invcdf 2">run</a>)
%   % Generate lognormally distributed samples
%   dist = gendist_create('lognormal', {1, 0.5});
%   y=rand(100000,1);
%   x=gendist_invcdf(y, dist);
%   hist(x, 100);
%
% See also GENDIST_CREATE, GENDIST_CDF, RAND

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

if isa(dist, 'Distribution')
    x = dist.invcdf(y);
    return
end

[distname, params, shift, scale, mean] = gendist_get_args(dist, varargin);

x=feval( [distname '_invcdf'], y, params{:} );
x=(x-mean)*scale+mean+shift;
