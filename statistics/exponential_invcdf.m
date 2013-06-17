function x=exponential_invcdf(y, lambda)
% EXPONENTIAL_INVCDF Inverse CDF of the Exponential distribution.
%   X=EXPONENTIAL_INVCDF( Y, LAMBDA ) computes the inverse cumulative distribution
%   function of the exponential distribution with parameter LAMBDA for the
%   values in Y, which should all be in [0,1]. This function can be used to
%   transform [0,1] uniformly distributed random numbers into exponentially
%   distributed random numbers. 
%
% Example (<a href="matlab:run_example exponential_invcdf">run</a>)
%   N=10000;
%   y=rand(N, 1);
%   x=exponential_invcdf(y, 3);
%   hist(x, 30);
%
% See also EXPONENTIAL_CDF, EXPONENTIAL_PDF, RAND

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

x=nan(size(y));
ind = (y>=0) & (y<=1);

x(ind)=-log(1-y(ind))/lambda;
