function unittest_svd_type
% UNITTEST_SVD_TYPE Test the SVD_TYPE_GET and _SET functions.
%
% Example (<a href="matlab:run_example unittest_svd_type">run</a>)
%   unittest_svd_type
%
% See also SVD_TYPE_GET, SVD_TYPE_SET, MUNIT_RUN_TESTSUITE 

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

munit_set_function( 'svd_type_get' );
S = rand(10,10);
assert_equals(svd_type_get(S), 'matrix', 'get_matrix');
assert_equals(svd_type_get(diag(S)), 'vector', 'get_vector');
assert_equals(svd_type_get([]), 'empty', 'get_empty');

munit_set_function( 'svd_type_get' );
A = rand(13, 10);
[U,S,V] = svd(A, 0);

% input type is matrix
[U1,S1,V1] = svd_type_set(U,S,V,'matrix'); 
assert_equals(U1*S1*V1', A, 'mat_mat'); 
[U1,S1,V1] = svd_type_set(U,S,V,'vector'); 
assert_equals(U1*diag(S1)*V1', A, 'mat_vec'); 
[U1,S1,V1] = svd_type_set(U,S,V,'empty'); 
assert_equals(U1*V1', A, 'mat_emp'); 
assert_equals(S1, [], 'mat_emp_S'); 

% input type is vector
S = diag(S);
[U1,S1,V1] = svd_type_set(U,S,V,'matrix'); 
assert_equals(U1*S1*V1', A, 'mat_mat'); 
[U1,S1,V1] = svd_type_set(U,S,V,'vector'); 
assert_equals(U1*diag(S1)*V1', A, 'mat_vec'); 
[U1,S1,V1] = svd_type_set(U,S,V,'empty'); 
assert_equals(U1*V1', A, 'mat_emp'); 
assert_equals(S1, [], 'mat_emp_S'); 

% input type is empty
U=U*diag(S); S = [];
[U1,S1,V1] = svd_type_set(U,S,V,'matrix'); 
assert_equals(U1*S1*V1', A, 'mat_mat'); 
[U1,S1,V1] = svd_type_set(U,S,V,'vector'); 
assert_equals(U1*diag(S1)*V1', A, 'mat_vec'); 
[U1,S1,V1] = svd_type_set(U,S,V,'empty'); 
assert_equals(U1*V1', A, 'mat_emp'); 
assert_equals(S1, [], 'mat_emp_S'); 

