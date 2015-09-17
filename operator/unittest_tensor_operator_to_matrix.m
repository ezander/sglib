function unittest_tensor_operator_to_matrix
% UNITTEST_TENSOR_OPERATOR_TO_MATRIX Test the TENSOR_OPERATOR_TO_MATRIX function.
%
% Example (<a href="matlab:run_example unittest_tensor_operator_to_matrix">run</a>)
%   unittest_tensor_operator_to_matrix
%
% See also TENSOR_OPERATOR_TO_MATRIX, MUNIT_RUN_TESTSUITE 

%   Elmar Zander
%   Copyright 2010, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'tensor_operator_to_matrix' );

N1=3; M1=6;
N2=2; M2=7;
N3=4; M3=5;
T22={ rand(N1,M1), rand(N2,M2); rand(N1,M1), rand(N2,M2) };
T23={ rand(N1,M1), rand(N2,M2); rand(N1,M1), rand(N2,M2); rand(N1,M1), rand(N2,M2) };
T32={ rand(N1,M1), rand(N2,M2), rand(N3,M3); rand(N1,M1), rand(N2,M2), rand(N3,M3) };

assert_equals( tensor_operator_to_matrix(T22), revkron(T22{1,1},T22{1,2})+revkron(T22{2,1},T22{2,2}), 'T22' );
assert_equals( tensor_operator_to_matrix(T23), revkron(T23{1,1},T23{1,2})+revkron(T23{2,1},T23{2,2})+revkron(T23{3,1},T23{3,2}), 'T23' );
assert_equals( tensor_operator_to_matrix(T32), revkron(revkron(T32{1,1},T32{1,2}),T32{1,3})+revkron(revkron(T32{2,1},T32{2,2}),T32{2,3}), 'T32' );
