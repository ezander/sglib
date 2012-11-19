function nrm2 = polysys_sqnorm(sys, n, method)
% POLYSYS_NORM Compute the square norm of the orthogonal polynomials.
%   NRM2 = POLYSYS_SQNORM(SYS, N) computes the square of the norm NRM2 of the
%   system of orthogonal polynomials given by SYS for the degree N. If N is
%   a vector a vector of square norms NRM is returned with the same shape.
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
% See also GPC_NORM

%   Elmar Zander
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
    % the most stupid errors.
    switch method
        case 'quad'
            nrm2 = polysys_sqnorm_by_quad(sys, n);
            return
        case 'mc'
            nrm2 = polysys_sqnorm_by_mc(sys, n);
            return
        otherwise
            % do nothing, fall through
    end
end

switch sys
    case 'H'
        nrm2 = factorial(n);
    case 'P'
        % Note: the U(-1,1) measure is used here, not the Lebesgue measure
        nrm2 = 1 ./ (2*n + 1);
    case 'T'
        nrm2 = 0.5*((n==0) + 1);
    case {'h', 'p', 't', 'u', 'U', 'l', 'L'}
        nrm2 = ones(size(n));
    otherwise
        nrm2 = polysys_sqnorm_by_quad(sys, n);
end

function nrm2 = polysys_sqnorm_by_quad(sys, n)
% POLYSYS_NORM_BY_QUAD Compute the square norm by Gauss quadrature.
m = max(n(:));
[x,w] = polysys_int_rule(sys, m+1);
y = gpc_evaluate(eye(m+1), {sys, (0:m)'}, x');
nrm2 = (y.*y)*w';
nrm2 = reshape(nrm2(n+1), size(n));

function nrm2 = polysys_sqnorm_by_mc(sys, n)
% POLYSYS_NORM_BY_MC Approximate the square norm by MC quadrature.
m = max(n(:));
N = 100000;
x = polysys_sample_rv(sys, 1, N);
y = gpc_evaluate(eye(m+1), {sys, (0:m)'}, x);
nrm2 = sum(y.*y,2)/N;
nrm2 = reshape(nrm2(n+1), size(n));
