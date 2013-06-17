function x=lognormal_invcdf(y, mu, sigma)
% LOGNORMAL_INVCDF Inverse CDF of the Lognormal distribution.
%   X=LOGNORMAL_INVCDF( Y, MU, SIGMA ) computes the inverse cumulative distribution
%   function of the lognormal distribution with parameters MU and SIGMA for the
%   values in Y, which should all be in [0,1]. This function can be used to
%   transform [0,1] uniformly distributed random numbers into lognormally
%   distributed random numbers. 
%
% Example (<a href="matlab:run_example lognormal_invcdf">run</a>)
%   N=10000;
%   y=rand(N, 1);
%   x=lognormal_invcdf(y, 0.2, 0.5);
%   hist(x, 30);
%
% See also LOGNORMAL_CDF, LOGNORMAL_PDF, RAND

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

x(ind) = exp(mu + sigma * sqrt(2) * erfinv(2*y(ind)-1));
