function [L, n]=covariance_decomp(C, varargin)
% COVARIANCE_DECOMP Factorise a covariance matrix.
%   [L, N]=COVARIANCE_DECOMP(C, VARARGIN) decomposes the covariance matrix
%   C into L'*L, returning the matrix L. The matrix C needs to symmetric
%   and positive semi-definite. If C is non-singular the Choleski
%   decomposition is used to factor C. If C is singular, L is computed
%   using the eigen decomposition (or LDL if specified as an option), and
%   the number of columns in L is returned in N. In this case L is not
%   lower triangular, but can be made so by specifying the 'always_lower'
%   option. 
%
% Options
%   'always_lower': {false}, true
%      Always return a lower triangular matrix, even if the decomposition
%      was computed using the eigenvalue decomposition.
%   'fillup': {false}, true
%      Make L a square matrix by filling up with zeros if C was singular.
%   'fallback_ldl': {false}, true
%      Use the LDL decomposition instead of the eigen decomposition as a
%      fallback in case C was non-positive definite.
%
% Example (<a href="matlab:run_example covariance_decomp">run</a>)
%   x = linspace(0,10,20);
%   cov_func = funcreate(@gaussian_covariance, funarg, funarg, 1, 0.1);
%   C = covariance_matrix(x, cov_func);
%   [L, n] = covariance_decomp(C);
%
%   % Generate correlated Gaussian random numbers using L 
%   xi = L * randn(n, 10000);
%   % and check empirical covariance (should be close to C)
%   C_mc = cov(xi');
%   norm(C_mc-C)/norm(C)
%
% See also COVARIANCE_MATRIX

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


options = varargin2options(varargin, mfilename);
[fillup, options]=get_option(options, 'fillup', false);
[always_lower, options]=get_option(options, 'always_lower', false);
[fallback_ldl, options]=get_option(options, 'fallback_ldl', false);
check_unsupported_options(options);

[L,p]=chol(C, 'lower');
if p>0
    % that indicates chol did not work 
    
    if ~fallback_ldl
        [U,D]=eig(C);
    else
        [U,D]=ldl(C);
    end
    d = diag(D);
    min_d = abs(max(d)) * 1e-14;
    ind = (d>min_d);
    L = binfun(@times, U(:,ind), sqrt(d(ind)'));
    
    if sum(-d(d<0)) > 1e-5 * sum(d(d>0))
        warning('sglib:covariance_decomp', 'Covariance matrix seems to be far from positive semi-definite. Please check your input.');
    end
    
    if always_lower
        % Note: is X=qr(A), then triu(X) is the upper triangular part of 
        % R where Q*R=A is the QR decomposition of A
        L=triu(qr(L'))';
    end
end

[m, n] = size(L);
if fillup && n<m
    L = [L, zeros(m, m-n)];
end

% assert( norm(L*L'-C)<1e-12*norm(C) )
