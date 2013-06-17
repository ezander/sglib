function x=normal_invcdf(y, mu, sigma)
% NORMAL_INVCDF Inverse CDF of the Normal distribution.
%   X=NORMAL_INVCDF(Y, MU, SIGMA) computes the inverse cumulative distribution
%   function of the normal distribution with parameters MU and SIGMA for the
%   values in Y, which should all be in [0,1]. This function can be used to
%   transform [0,1] uniformly distributed random numbers into Normal
%   distributed random numbers. 
%
% Example (<a href="matlab:run_example normal_invcdf">run</a>)
%   N=10000;
%   y=rand(N, 1);
%   x=normal_invcdf(y, 2, 4);
%   hist(x, 30);
%
% See also NORMAL_CDF, NORMAL_PDF, RAND

%   Elmar Zander
%   Copyright 2013, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

if nargin<2
    mu=0;
end
if nargin<3
    sigma=1;
end

x=nan(size(y));
ind = (y>=0) & (y<=1);

x(ind) = mu + sigma * sqrt(2) * erfinv(2*y(ind)-1);
