function y=uniform_stdnor( x, a, b )
% UNIFORM_STDNOR Transforms standard normal random numbers into uniform distributed ones.
%   Y=UNIFORM_STDNOR( X, A, B ) transforms standard normal (i.e. N(0,1))
%   distributed random numbers into uniform distributed random numbers. A
%   and B default to 0 and 1 respectively.
%
% Example (<a href="matlab:run_example uniform_stdnor">run</a>)
%   N=10000;
%   x=randn(N,1);
%   y=uniform_stdnor(x,2,4);
%   hist(y);
%
% See also UNIFORM_CDF, UNIFORM_PDF

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


if nargin<2
    a=0;
end
if nargin<3
    b=1;
end

y=a+0.5*(b-a)*( 1 + erf(x/sqrt(2)));
