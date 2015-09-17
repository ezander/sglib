function y=exponential_cdf( x, lambda )
% EXPONENTIAL_CDF Cumulative distribution function of the exponential distribution.
%   Y=EXPONENTIAL_CDF( X, LAMBDA ) computes the cdf for the exponential distribution for
%   all values in X, which may be a vector.
%
% Example (<a href="matlab:run_example exponential_cdf">run</a>)
%   x=linspace(-0.2,3);
%   f=exponential_pdf(x,1.3);
%   F=exponential_cdf(x,1.3);
%   plot(x,F,x,cumsum(f)*(x(2)-x(1)) )
%
% See also EXPONENTIAL_PDF

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


y=zeros(size(x));
ind=(x>=0);
y(ind)=1-exp( -lambda*x(ind) );
