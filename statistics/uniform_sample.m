function xi = uniform_sample(n, a, b)
% UNIFORM_SAMPLE Draws random samples from the lognormal distribution.
%   XI = UNIFORM_SAMPLE(N, A, B) draws N random samples from the uniform
%   random distribution on the interval [A, B]. If N is a scalar value XI
%   is a column vector of random samples of size [N,1]. If N is a vector XI
%   is a matrix (or tensor) of size [N(1), N(2), ...].
%
% Example (<a href="matlab:run_example uniform_sample">run</a>)
%   % sample from a uniform distribution with parameters a=2 and b=5
%   xi = uniform_sample(100000, 2, 5);
%   hist(xi, 100);
%   fprintf('sample mean: %g sample std: %g\n', mean(xi), std(xi));
%   [m,v]=uniform_moments(2, 5);
%   fprintf('exact mean: %g std dev: %g\n', m, sqrt(v));
%
% See also UNIFORM_MOMENTS, UNIFORM_PDF, RAND, GENDIST_SAMPLE

%   Elmar Zander
%   Copyright 2015, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

if nargin<2
    a=0;
end
if nargin<3
    b=1;
end

if isscalar(n)==1
    xi = rand(n,1);
else
    xi = rand(n);
end
xi = uniform_invcdf(xi, a, b);
