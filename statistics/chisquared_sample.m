function xi=chisquared_sample(n, k)
% CHISQUARED_SAMPLE Draws random samples from the Chi-squared distribution.
%   XI=CHISQUARED_SAMPLE(N, K) draws N random samples from the Chi-squared
%   distribution with K degrees of freedom. If N is a scalar value XI is a
%   column vector of random samples of size [N,1]. If N is a vector XI is a
%   matrix (or tensor) of size [N(1), N(2), ...].
%
% Note
%   This method does not use the inverse CDF transform method to generate
%   the sample, but generates K random normal samples per output value, and
%   computes the sum of the squares of those values.
%
% Example (<a href="matlab:run_example chisquared_sample">run</a>)
%   % sample from a chisquared distribution with mean 2 and standard dev. 0.3
%   xi = chisquared_sample(100000, 3 );
%   hist(xi, 100);
%
% See also CHISQUARED_MOMENTS, CHISQUARED_PDF, CHISQUARED_CDF, CHISQUARED_INVCDF, RANDN

%   Elmar Zander
%   Copyright 2014, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

if isscalar(n)==1
    n = [n, 1];
end
xi = sum(randn([k, prod(n)]).^2,1);
xi = reshape(xi, n);
