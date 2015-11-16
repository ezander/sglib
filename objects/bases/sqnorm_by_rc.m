function nrm2 = sqnorm_by_rc(rc)
% POLYSYS_NORM_BY_RC Compute the square norm via the recurrence coefficients.
% See the neat article by:
%    Alan G. Law and M. B. Sledd
%    Normalizing Orthogonal Polynomials by Using their Recurrence Coefficients
%    Proceedings of the American Mathematical Society, Vol. 48, No. 2
%    (Apr., 1975), pp. 505 - 507
%    URL: http://www.jstor.org/stable/2040291
%
% Note that here the symbols a and b are reversed compared to the article
% by Law and Sled. Further, as we're doing stochastics here, we can be sure
% what the normalisation constant is (namely 1).
%
% Example (<a href="matlab:run_example sqnorm_by_rc">run</a>)
%
% See also

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

b = rc(:,2);
h = b(1) ./ b(2:end);
c = rc(2:end,3);
nrm2 = [1; h(:) .* cumprod(c(:))];
