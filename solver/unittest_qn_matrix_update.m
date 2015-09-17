function unittest_qn_matrix_update
% UNITTEST_QN_MATRIX_UPDATE Test the QN_MATRIX_UPDATE function.
%
% Example (<a href="matlab:run_example unittest_qn_matrix_update">run</a>)
%   unittest_qn_matrix_update
%
% See also QN_MATRIX_UPDATE, MUNIT_RUN_TESTSUITE 

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

munit_set_function( 'qn_matrix_update' );

%
N=6;
A1 = rand(N);
B1 = A1'*A1+eye(N);
H1 = inv(B1);

y = rand(N,1);
s = rand(N,1);

[B2, H2] = qn_matrix_update('dfp', B1, H1, y, s);
assert_matrix(B2*H2, 'identity', 'id_dfp');
assert_matrix(B2, 'symmetric', 'sym_B_dfp', 'abstol', 0, 'reltol', 0);
assert_matrix(H2, 'symmetric', 'sym_H_dfp', 'abstol', 0, 'reltol', 0);
[B2b, H2b] = qn_matrix_update('dfp', [], H1, y, s);
assert_equals({B2b, H2b}, {[], H2}, 'argH_dfp');
[B2b, H2b] = qn_matrix_update('dfp', B1, [], y, s);
assert_equals({B2b, H2b}, {B2, []}, 'argB_dfp');


[B2, H2] = qn_matrix_update('bfgs', B1, H1, y, s);
assert_matrix(B2*H2, 'identity', 'id_bfgs');
assert_matrix(B2, 'symmetric', 'sym_B_bfgs', 'abstol', 0, 'reltol', 0);
assert_matrix(H2, 'symmetric', 'sym_H_bfgs', 'abstol', 0, 'reltol', 0);
[B2b, H2b] = qn_matrix_update('bfgs', [], H1, y, s);
assert_equals({B2b, H2b}, {[], H2}, 'argH_bfgs');
[B2b, H2b] = qn_matrix_update('bfgs', B1, [], y, s);
assert_equals({B2b, H2b}, {B2, []}, 'argB_bfgs');

[B2a, H2a] = qn_matrix_update('dfp', B1, H1, y, s);
[H2b, B2b] = qn_matrix_update('bfgs', H1, B1, s, y);
assert_equals({B2a, H2a}, {B2b, H2b}, 'dfp_bfgs_duality');



[B2, H2] = qn_matrix_update('sr1', B1, H1, y, s);
assert_matrix(B2*H2, 'identity', 'id_sr1');
assert_matrix(B2, 'symmetric', 'sym_B_sr1', 'abstol', 0, 'reltol', 0);
assert_matrix(H2, 'symmetric', 'sym_H_sr1', 'abstol', 0, 'reltol', 0);
[B2b, H2b] = qn_matrix_update('sr1', [], H1, y, s);
assert_equals({B2b, H2b}, {[], H2}, 'argH_sr1');
[B2b, H2b] = qn_matrix_update('sr1', B1, [], y, s);
assert_equals({B2b, H2b}, {B2, []}, 'argB_sr1');


B1 = A1;
H1 = inv(B1);
[B2, H2] = qn_matrix_update('broyden', B1, H1, y, s);
assert_matrix(B2*H2, 'identity', 'id_broyden');
[B2b, H2b] = qn_matrix_update('broyden', [], H1, y, s);
assert_equals({B2b, H2b}, {[], H2}, 'argH_broyden');
[B2b, H2b] = qn_matrix_update('broyden', B1, [], y, s);
assert_equals({B2b, H2b}, {B2, []}, 'argB_broyden');


