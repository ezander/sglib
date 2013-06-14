function y=beta_stdnor( x, a, b )
% BETA_STDNOR Transforms standard normal random numbers into beta distributed ones.
%   Y=BETA_STDNOR( X, A, B ) transforms standard normal (i.e. N(0,1))
%   distributed random numbers into beta distributed random numbers.
%
% Caveat:
%   Since this function uses the inverse regularized beta function (I_z^-1)
%   it is pretty slow. May be some interpolation algorithm shall be used
%   and the time consuming evaluation of I_z^-1 only done on some points.
%
% Example (<a href="matlab:run_example beta_stdnor">run</a>)
%   N=10000;
%   x=randn(N,1);
%   y=beta_stdnor(x,2,4); % SLOW!
%   hist(y);
%
% See also BETA_CDF, BETA_PDF

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


%y=inv_reg_beta( 0.5*(1+erf(x/sqrt(2))), a, b );
y=beta_invcdf(normal_cdf(x, 0, 1), a, b);
