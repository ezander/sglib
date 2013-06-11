function y=exponential_stdnor( x, lambda )
% EXPONENTIAL_STDNOR Transforms standard normal random numbers into exponential distributed ones.
%   Y=exponential_STDNOR( X, LAMBDA ) transforms standard normal (i.e. N(0,1))
%   distributed random numbers into exponential EXP(LAMBDA) distributed random numbers.
%
% Example (<a href="matlab:run_example exponential_stdnor">run</a>)
%   N=10000;
%   x=randn(N,1);
%   y=exponential_stdnor(x,1.3);
%   hist(y);
%
% See also EXPONENTIAL_CDF, EXPONENTIAL_PDF

%   Elmar Zander
%   Copyright 2006, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


y=(log(2)-log(erfc(x/sqrt(2))))/lambda;
