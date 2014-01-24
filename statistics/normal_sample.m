function xi=normal_sample(n, mu, sigma)
% NORMAL_SAMPLE Draws random samples from the normal distribution.
%   XI=NORMAL_SAMPLE(N, MU, SIGMA) draws N random samples from the random
%   distribution with mean MU and variance SIGMA^2. If N is a scalar value
%   XI is a column vector of random samples of size [N,1]. If N is a vector
%   XI is a matrix (or tensor) of size [N(1), N(2), ...].
%
% Example (<a href="matlab:run_example normal_sample">run</a>)
%   % sample from a normal distribution with mean 2 and standard dev. 0.3
%   xi = normal_sample(100000, 2, 0.3 );
%   fprintf('sample mean: %g sample std: %g\n', mean(xi), std(xi));
%   hist(xi, 100);
%
% See also NORMAL_MOMENTS, NORMAL_PDF, NORMAL_CDF, NORMAL_INVCDF, RANDN

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
    xi = randn(n,1);
else
    xi = randn(n);
end
xi = (xi * sigma) + mu;
