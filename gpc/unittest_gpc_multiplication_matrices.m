function unittest_gpc_multiplication_matrices
% UNITTEST_GPC_MULTIPLICATION_MATRICES Test the GPC_MULTIPLICATION_MATRICES function.
%
% Example (<a href="matlab:run_example unittest_gpc_multiplication_matrices">run</a>)
%   unittest_gpc_multiplication_matrices
%
% See also GPC_MULTIPLICATION_MATRICES, MUNIT_RUN_TESTSUITE 

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

munit_set_function( 'gpc_multiplication_matrices' );

% Create some bases and fields to do the tests on
V = gpcbasis_create('HpL');
V_a = gpcbasis_create(V, 'p', 3);
V_u = gpcbasis_create(V, 'p', 4);
V_v = gpcbasis_create(V, 'p', 7);
ind_u_in_v = multiindex_find(V_u{2}, V_v{2});

R = 5; M=3;
a_i_alpha = rand(R, gpcbasis_info(V_a, 'size'));
u_i_alpha = rand(M, gpcbasis_info(V_u, 'size'));

% Test with evaluation of the multiplication
A=gpc_multiplication_matrices(a_i_alpha, V_a, V_u, V_v, 'normalise', true);
xi = gpcgerm_sample(V_a, 10);
v3_i_alpha = u_i_alpha * A{3};
v3_i = gpc_evaluate(v3_i_alpha, V_v, xi);
a_i = gpc_evaluate(a_i_alpha, V_a, xi);
u_i = gpc_evaluate(u_i_alpha, V_u, xi);
v3_i_ex = binfun(@times, a_i(3,:), u_i);
assert_equals(v3_i, v3_i_ex, 'mult3');

% Test whether the matrices are submatrices of the exact ones (testing
% against multiplication would not work here, as the gpc multiplication is
% not exact if the result degree is too low as in this case)
Ap=gpc_multiplication_matrices(a_i_alpha, V_a, V_u, V_u, 'normalise', true);
assert_equals(Ap{2}, A{2}(:,ind_u_in_v), 'vu');

A=gpc_multiplication_matrices(a_i_alpha, V_a, V_u, [], 'normalise', true);
assert_equals(Ap{2}, A{2}(:,ind_u_in_v), 'empty');

A=gpc_multiplication_matrices(a_i_alpha, V_a, V_u, 'normalise', true);
assert_equals(Ap{2}, A{2}(:,ind_u_in_v), 'skipped');

A=gpc_multiplication_matrices(a_i_alpha, V_a, V_u);
assert_equals(Ap{2}, A{2}(:,ind_u_in_v), 'default');


% Test against integration
V_v = gpcbasis_create(V, 'p', 5);
A=gpc_multiplication_matrices(a_i_alpha, V_a, V_u, V_v, 'normalise', false);
p_int = ceil((3+4+5)/2) + 1;
[x,w] = gpc_integrate([], V, p_int, 'grid', 'full_tensor');

a_i = gpc_evaluate(a_i_alpha, V_a, x);
u_alpha_j = gpcbasis_evaluate(V_u, x);
v_alpha_j = gpcbasis_evaluate(V_v, x);
D = spdiags(a_i(2,:)'.*w, 0, length(w), length(w));
A2 = u_alpha_j * D * v_alpha_j';
assert_equals(A{2}, A2, 'integrate')


