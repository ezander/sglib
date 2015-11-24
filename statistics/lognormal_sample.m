function xi=lognormal_sample(n, mu, sigma)
% LOGNORMAL_SAMPLE Draws random samples from the lognormal distribution.
%   XI=LOGNORMAL_SAMPLE(N, MU, SIGMA) draws N random samples from the lognormal  random
%   distribution with parameters MU and SIGMA. If N is a scalar value
%   XI is a column vector of random samples of size [N,1]. If N is a vector
%   XI is a matrix (or tensor) of size [N(1), N(2), ...].
%
% Example (<a href="matlab:run_example lognormal_sample">run</a>)
%   % sample from a lognormal distribution with parameters mu 2 and sigma 0.3
%   xi = lognormal_sample(100000, 2, 0.3 );
%   hist(xi, 100);
%   fprintf('sample mean: %g sample std: %g\n', mean(xi), std(xi));
%   [m,v]=lognormal_moments(2, 0.3);
%   fprintf('exact mean: %g std dev: %g\n', m, sqrt(v));
%
% See also LOGNORMAL_MOMENTS, LOGNORMAL_PDF, RANDN

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

xi=exp(normal_sample(n, mu, sigma));
