function y=beta_invcdf(x, a, b)
% BETA_INVCDF Inverse CDF of the Beta distribution.
%   Y=BETA_INVCDF( X, A, B ) computes the inverse cumulative distribution
%   function of the Beta distribution with parameters A and B for the
%   values in X, which should all be in [0,1]. This function can be used to
%   transform [0,1] uniformly distributed random numbers into Beta
%   distributed random numbers. 
%
% Caveat:
%   Since this function uses the inverse regularized beta function (I_z^-1)
%   it is pretty slow. May be some interpolation algorithm shall be used
%   and the time consuming evaluation of I_z^-1 only done on some points.
%
% Example (<a href="matlab:run_example beta_invcdf">run</a>)
%   N=10000;
%   x=rand(N,1);
%   y=beta_invcdf(x,2,4);
%   hist(y);
%
% See also BETA_CDF, BETA_PDF, RAND

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

y=nan(size(x));
ind = (x>=0) & (x<=1);

if a==1 && b==1
    % Beta(1,1) is same as Uniform([0,1])
    y(ind) = x(ind);
elseif a==0.5 && b==0.5
    % Beta(0.5, 0.5) is same as Arcsine
    y(ind) = 0.5 * (sin(pi*(x(ind)-0.5)) + 1);
else
    y(ind)=inv_reg_beta(x(ind), a, b );
    %Note Beta(1.5, 1.5) is the same as the semicircle distribution but
    %that cannot be used to speed up evaluation. What could be used is the
    %equivalence to the Kumaraswamy distribution if A or B is 1
end
