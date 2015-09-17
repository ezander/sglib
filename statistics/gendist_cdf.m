function y=gendist_cdf(x, dist, varargin)
% GENDIST_CDF Cumulative distribution function of a gendist.
%   Y=GENDIST_CDF( X, DIST) computes the cdf for the for probablity
%   distribution DIST for all values in X, which may be a vector.
%
% Example (<a href="matlab:run_example gendist_cdf">run</a>)
%   % create a lognormal distribution shifted by 2 to the right
%   dist = gendist_create('lognormal', {0, 1}, 'shift', 2);
%   x = linspace(0, 7);
%   plot(x, gendist_cdf(x, dist));
%
% See also GENDIST_CREATE, GENDIST_PDF, GENDIST_INVCDF, GENDIST_MOMENTS

%   Elmar Zander
%   Copyright 2009, Inst. of Scientific Computing
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

if isa(dist, 'Distribution')
    y = dist.cdf(x);
    return
end

[distname, params, shift, scale, mean] = gendist_get_args(dist, varargin);

x=(x-shift-mean)/scale+mean;
y=feval( [distname '_cdf'], x, params{:} );
