function q = empirical_invcdf(y, x)
% EMPIRICAL_INVCDF Computes the empirical quantile function.
%   Q = EMPIRICAL_INVCDF(Y, X) computes the quantiles Q at X given the data
%   (samples) in Y.
%
% Example (<a href="matlab:run_example empirical_invcdf">run</a>)
%   dist = gendist_create('normal', {2, 3});
%   x = [0.025, 0.975];
%   y = gendist_sample(10000, dist);
%   strvarexpand('True quantiles: $gendist_invcdf(x, dist)$')
%   strvarexpand('Quantiles from samples: $empirical_invcdf(y, x)$')
%
% See also GENDIST_INVCDF

%   Elmar Zander
%   Copyright 2018, Inst. of Scientific Computing
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

yi = sort(y);
n = length(y);
xi = linspace_midpoints(0, 1, n);
q = interp1(xi, yi, x, 'pchip');
