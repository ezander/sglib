function x=chisquared_invcdf(y, k)
% CHISQUARED_INVCDF Inverse CDF of the Chi-squared distribution.
%   X=CHISQUARED_INVCDF( Y, K ) computes the inverse cumulative
%   distribution function of the Chi-squared distribution with K degrees of
%   freedom for the values in Y, which should all be in [0,1]. 
%
% Note
%   This function can be used to transform [0,1] uniformly distributed
%   random numbers into Chi-squared distributed random numbers. Of course
%   you can do that more efficiently (as long as K is not very large) by
%   summing the squares of K normally distributed random numbers.
%
% Example (<a href="matlab:run_example chisquared_invcdf">run</a>)
%   % This examples shows sampling by two different methods and
%   % compares it to the true pdf
%   N=100000; k=4;
%   xi=rand(N, 1);
%   ch1=chisquared_invcdf(xi, k);
%   kernel_density(ch1); hold all; 
%   ch2=sum(randn(N, k).^2,2);
%   kernel_density(ch2); 
%   x=linspace(0,12);
%   plot(x,chisquared_pdf(x,k));
%   hold off; xlim([0,12])
%
% See also CHISQUARED_CDF, CHISQUARED_PDF, RAND

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
x(ind)=2*gammaincinv(y(ind), k/2);

