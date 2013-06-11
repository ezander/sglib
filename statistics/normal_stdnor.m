function y=normal_stdnor( x, mu, sigma )
% NORMAL_STDNOR Transforms standard normal random numbers into normal distributed ones.
%   Y=NORMAL_STDNOR( X, MU, SIGMA ) transforms standard normal (i.e. N(0,1))
%   distributed random numbers into normal N(MU,SIGMA^2) distributed random numbers.
% Note:
%   This is of course trivial, but make the interface for the normal
%   distribution the same as for the other distributions.
%
% Example (<a href="matlab:run_example normal_stdnor">run</a>)
%   N=10000;
%   x=randn(N,1);
%   y=normal_stdnor(x,1,0.5);
%   hist(y);
%
% See also NORMAL_CDF, NORMAL_PDF

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
    mu=0;
end
if nargin<3
    sigma=1;
end

y=mu+sigma*x;
