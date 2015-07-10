function xi=gendist_sample(n, dist)
% GENDIST_SAMPLE Draw random samples from a gendist.
%   XI=GENDIST_SAMPLE(N, DIST) draws N random samples from the random
%   distribution DIST. If N is a scalar value XI is a column vector of
%   random samples of size [N,1]. If N is a vector XI is a matrix (or
%   tensor) of size [N(1), N(2), ...].
%
% Example (<a href="matlab:run_example gendist_sample">run</a>)
%   dist = gendist_create('normal', {2, 0.3}, 'shift', 1, 'scale', 2);
%   xi = gendist_sample(100000, dist);
%   fprintf('sample mean: %g sample std: %g\n', mean(xi), std(xi));
%   [mn, vr] = gendist_moments(dist);
%   fprintf('true mean: %g true std: %g\n', mn, sqrt(vr));
%
%   dist = gendist_create('beta', {1.2, 0.6}, 'shift', 2, 'scale', 1);
%   xi = gendist_sample(100000, dist);
%   fprintf('sample mean: %g sample std: %g\n', mean(xi), std(xi));
%   [mn, vr] = gendist_moments(dist);
%   fprintf('true mean: %g true std: %g\n', mn, sqrt(vr));
%
% See also GENDIST_CREATE, GENDIST_MOMENTS, GENDIST_PDF

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

if isa(dist, 'Distribution')
    xi = dist.sample(n);
    return
end

[distname, params, shift, scale, mean] = gendist_get_args(dist);
sample_func = [distname '_sample'];
if exist(sample_func, 'file')
    x = feval(sample_func, n, params{:});
    xi = (x - mean) * scale + mean + shift;
else
    if isscalar(n)
        y = rand(n,1);
    else
        y = rand(n);
    end
    xi = gendist_invcdf(y, dist);
end
