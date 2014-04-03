function cov_ab_ij=gpc_covariance(a_i_alpha, V_ab, b_j_alpha)
% GPC_COVARIANCE Compute covariance matrix between GPC variables.
%   COV_AB_IJ=GPC_COVARIANCE(A_I_ALPHA, V_AB, B_J_ALPHA) computes the
%   covariance between the GPC random variables A_I_ALPHA and B_J_ALPHA
%   which need to live on the same GPC basis given by V_AB. If A_I_ALPHA is
%   of size NA x M and B_J_ALPHA is of size NB x M then the result
%   COV_AB_IJ is a matrix of size NA x NB.
%
%   COV_IJ=GPC_COVARIANCE(A_I_ALPHA, V_A) computes the covariance matrix of
%   the GPC random variables A_I_ALPHA with GPC basis V_A. If A_I_ALPHA is
%   of size NA x M  then the result COV_IJ is a matrix of size NA x NA.
%
% Example (<a href="matlab:run_example gpc_covariance">run</a>)
%   V = gpcbasis_create('hh', 'p', 4);
%   a_alpha = rand(3, gpcbasis_size(V, 1));
%   gpc_covariance(a_alpha, V, a_alpha)
%
% See also GPCBASIS_CREATE, GPC

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

% if B is not specified we compute the (auto-) covariance of A
if nargin<3
    b_j_alpha = a_i_alpha;
end

% compute the square of the norm of the GPC basis
nrm2 = gpcbasis_norm(V_ab, 'sqrt', false)';

% determine all multiindices not belonging to the mean
ind = (multiindex_order(V_ab{2})~=0);

% compute weighted inner product between A and B giving the covariance 
cov_ab_ij = binfun(@times, a_i_alpha(:, ind), nrm2(:,ind)) * b_j_alpha(:, ind)';
