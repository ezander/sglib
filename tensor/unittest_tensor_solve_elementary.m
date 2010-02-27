function unittest_tensor_solve_elementary
% UNITTEST_TENSOR_SOLVE_ELEMENTARY Test the TENSOR functions.
%
% Example (<a href="matlab:run_example unittest_tensor_solve_elementary">run</a>)
%    unittest_tensor_solve_elementary
%
% See also TESTSUITE

%   Elmar Zander
%   Copyright 2007, Institute of Scientific Computing, TU Braunschweig.
%   $Id$
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


munit_set_function( 'tensor_operator_solve_elementary' );


T={rand(8,2), rand(10,2)};
M1=rand(8); M1=M1*M1';
M2=rand(10); M2=M2*M2';
A={M1+eye(size(M1)), M2+eye(size(M2))};
L1=linear_operator_from_matrix(A{1});
L2=linear_operator_from_matrix(A{2});
Uex=tensor_operator_apply_elementary({inv(A{1}),inv(A{2})},T);
U1=tensor_operator_solve_elementary(A,T);
U2=tensor_operator_solve_elementary({L1,L2},T);
assert_equals( U1{1}*U1{2}', Uex{1}*Uex{2}' );
assert_equals( U2{1}*U2{2}', Uex{1}*Uex{2}' );
