function nrm2 = polysys_sqnorm(syschar, n, method)
% POLYSYS_SQNORM Compute the square norm of the orthogonal polynomials.
%   NRM2 = POLYSYS_SQNORM(SYSCHAR, N) computes the square of the norm NRM2
%   of the system of orthogonal polynomials given by SYSCHAR for the degree
%   N. If N is a vector a vector of square norms NRM is returned with the
%   same shape.
%
%   Note: Normally you don't want to call this function directly. Call one
%   of the GPC functions instead.
%
% Example (<a href="matlab:run_example polysys_norm">run</a>)
%   disp(rats(polysys_sqnorm('H', 0:5),4));
%   disp(rats(polysys_sqnorm('h', 0:5),4));
%   disp(rats(polysys_sqnorm('P', 0:5),4));
%   disp(rats(polysys_sqnorm('p', 0:5),4));
%
% See also GPCBASIS_NORM

%   Elmar Zander, Noemi Friedman
%   Copyright 2012, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

if nargin>=3
    % Those methods can be used if the norms are not known explicitly. The
    % MC method is not accurate at all: its purpose is for checking against
    % the most stupid errors. Best (and coolest) of the three, is the one
    % using only the recurrence coefficients.
    switch method
        case 'quad'
            nrm2 = polysys_sqnorm_by_quad(syschar, n);
            return
        case 'rc'
            nrm2 = polysys_sqnorm_by_rc(syschar, n);
            return
        case 'mc'
            nrm2 = polysys_sqnorm_by_mc(syschar, n);
            return
        case 'default'
            % do nothing, fall through
        otherwise
            error('sglib:gpc:sqnorm', 'Unknown method: %s', method);
    end
end

switch syschar
    case 'H'
        nrm2 = factorial(n);
    case 'P'
        % Note: the U(-1,1) measure is used here, not the Lebesgue measure
        nrm2 = 1 ./ (2*n + 1);
    case 'T'
        nrm2 = 0.5*((n==0) + 1);
    case {'M', 'm'}
        error('sglib:polysys_sqrnorm', 'There is no measure associated with the monomials');
    case {'h', 'p', 't', 'u', 'U', 'l', 'L'}
        nrm2 = ones(size(n));
    otherwise
        polysys = gpc_registry('get', syschar);
        if isempty(polysys)
            error('sglib:gpc:polysys', 'Unknown polynomials system: %s', syschar);
        end
        nrm2 = polysys.sqnorm(n);
end

end

function nrm2 = polysys_sqnorm_by_quad(syschar, I)
% POLYSYS_NORM_BY_QUAD Compute the square norm by Gauss quadrature.
n = max(I(:));
[x,w] = polysys_int_rule(syschar, n+1);
y = gpc_evaluate(eye(n+1), {syschar, (0:n)'}, x);
nrm2 = (y.*y)*w;
nrm2 = reshape(nrm2(I+1), size(I));
end

function nrm2 = polysys_sqnorm_by_rc(syschar, I)
% POLYSYS_NORM_BY_RC Compute the square norm via the recurrence coefficients.
% See the neat article by:
%    Alan G. Law and M. B. Sledd
%    Normalizing Orthogonal Polynomials by Using their Recurrence Coefficients
%    Proceedings of the American Mathematical Society, Vol. 48, No. 2
%    (Apr., 1975), pp. 505 - 507
%    URL: http://www.jstor.org/stable/2040291
% Note that here the symbols a and b are reversed compared to the article
% by Law and Sled. Further, as we're doing stochastics here, we can be sure
% what the normalisation constant is (namely 1).
n = max(I(:));
r = polysys_recur_coeff(syschar, n+1);
b = r(:,2);
h = b(1) ./ b(2:end);
c = r(2:end,3);
nrm2 = [1; h(:) .* cumprod(c(:))];
nrm2 = reshape(nrm2(I+1), size(I));
end

function nrm2 = polysys_sqnorm_by_mc(syschar, I)
% POLYSYS_NORM_BY_MC Approximate the square norm by MC quadrature.
n = max(I(:));
N = 100000;
x = polysys_sample_rv(syschar, 1, N);
y = gpc_evaluate(eye(n+1), {syschar, (0:n)'}, x);
nrm2 = sum(y.*y,2)/N;
nrm2 = reshape(nrm2(I+1), size(I));
end
