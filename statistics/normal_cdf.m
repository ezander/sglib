function y=normal_cdf( x, mu, sigma )
% NORMAL_CDF Cumulative distribution function of the normal distribution.
%   Y=NORMAL_CDF( X, MU, SIGMA ) computes the cdf for the normal
%   distribution for all values in X, which may be a vector. MU and SIGMA
%   can be specified optionally.
%
% Example (<a href="matlab:run_example normal_cdf">run</a>)
%   x=linspace(-1,5);
%   f=normal_pdf(x,2,.5);
%   F=normal_cdf(x,2,.5);
%   plot(x,F,x,cumsum(f)*(x(2)-x(1)) )
%
% See also NORMAL_PDF

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

y=1/2*(1+erf( (x-mu)/(sigma*sqrt(2)) ));
