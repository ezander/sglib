function unittest_gpc_reduce_basis_dim(varargin)
% UNITTEST_GPC_REDUCE_BASIS_DIM Test the GPC_REDUCE_BASIS_DIM function.
%
% Example (<a href="matlab:run_example unittest_gpc_reduce_basis_dim">run</a>)
%   unittest_gpc_reduce_basis_dim
%
% See also GPC_REDUCE_BASIS_DIM, MUNIT_RUN_TESTSUITE 

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

munit_set_function( 'gpc_reduce_basis_dim' );
%%
%munit_control_rand('seed', 1234);
V_r = gpcbasis_create('hlpuPt', 'p', 4);
r_i_alpha = gpc_rand_coeffs(V_r, 1, 'order_decay', 0.8);


%[r_i_beta, V_r12] = gpc_reduce_basis_dim(r_i_alpha, V_r,  [1,2]);
%plot_response_surface(r_i_beta(1,:), V_r12)

% [r_i_beta, V_rn] = gpc_reduce_basis_dim(r_i_alpha, V_r,  [1,2]);
% assert_equals(V_rn{1}, 'hl', 'germ');
% 
% V_rn
% 
% 
% [r_i_beta, V_rn] = gpc_reduce_basis_dim(r_i_alpha, V_r,  [1,4]);
% assert_equals(V_rn{1}, 'hu', 'germ');

%%
[r_i_beta, V_rn] = gpc_reduce_basis_dim(r_i_alpha, V_r,  [4,1]);
assert_equals(V_rn{1}, 'uh', 'germ');





