function y=chisquared_cdf( x, k )
% CHISQUARED_CDF Cumulative distribution function of the Chi-squared distribution.
%   Y=CHISQUARED_CDF( X, K ) computes the cdf for the Chi-squared
%   distribution with K degrees of freedom. X may be a vector, in which
%   case Y will have the same shape as X.
%
% Note
%   Compared to the reference [1] the implementation of the incomplete
%   gamma function in matlab has the parameters reversed and is already by
%   the inverse of the gamma function.
%
% References
%   [1] http://en.wikipedia.org/wiki/Chi-squared_distribution
%
% Example (<a href="matlab:run_example chisquared_cdf">run</a>)
%   x=linspace(-0.1,8);
%   f=chisquared_cdf(x,1);
%   for k=[2,3,4,6,9]
%     f=[f; chisquared_cdf(x,k)];
%   end
%   plot(x,f); grid on;
%
% See also CHISQUARED_PDF

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
ind=(x>0);

y(ind)=gammainc(x(ind)/2, k/2, 'lower');
