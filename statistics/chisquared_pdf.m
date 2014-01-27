function y=chisquared_pdf( x, k )
% CHISQUARED_PDF Probability distribution function of the Chi-squared distribution.
%   Y=CHISQUARED_PDF( X, K ) computes the pdf for the Chi-squared
%   distribution with K degrees of freedom. X may be a vector, in which
%   case Y will have the same shape as X.
%
% References
%   [1] http://en.wikipedia.org/wiki/Chi-squared_distribution
%
% Example 1 (<a href="matlab:run_example chisquared_pdf 1">run</a>)
%   x=linspace(-0.1,8);
%   f=chisquared_pdf(x, 1);
%   for k=[2,3,4,6,9]
%     f=[f; chisquared_pdf(x,k)];
%   end
%   plot(x,f); grid on;
%
% Example 2 (<a href="matlab:run_example chisquared_pdf 2">run</a>)
%   x=linspace(0,9);
%   f=chisquared_pdf(x,4);
%   F=chisquared_cdf(x,4);
%   plot(x,f,x(2:end)-diff(x(1:2)/2),diff(F)/(x(2)-x(1)))
%
% See also CHISQUARED_CDF


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
y(ind)=1/(2^(k/2)*gamma(k/2)) * x(ind).^(k/2-1) .* exp(-x(ind)/2);
y(isnan(y))=0;
