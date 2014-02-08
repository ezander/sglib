function unittest_tensor_operator_size
% UNITTEST_TENSOR_OPERATOR_SIZE Test the TENSOR_OPERATOR_SIZE function.
%
% Example (<a href="matlab:run_example unittest_tensor_operator_size">run</a>)
%   unittest_tensor_operator_size
%
% See also TENSOR_OPERATOR_SIZE, MUNIT_RUN_TESTSUITE 

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

munit_set_function( 'tensor_operator_size' );

N1=3; M1=6;
N2=2; M2=7;
N3=4; M3=5;
T22={ rand(N1,M1), rand(N2,M2); rand(N1,M1), rand(N2,M2) };
T23={ rand(N1,M1), rand(N2,M2); rand(N1,M1), rand(N2,M2); rand(N1,M1), rand(N2,M2) };
T32={ rand(N1,M1), rand(N2,M2), rand(N3,M3); rand(N1,M1), rand(N2,M2), rand(N3,M3) };

assert_equals ( tensor_operator_size( T22 ), [N1 M1; N2 M2], 'T22' );
assert_equals ( tensor_operator_size( T22, true ), [N1*N2 M1*M2], 'T22contract' );
assert_equals ( tensor_operator_size( T23 ), [N1 M1; N2 M2], 'T23' );
assert_equals ( tensor_operator_size( T32 ), [N1 M1; N2 M2; N3 M3], 'T32' );
assert_equals ( tensor_operator_size( T32, true ), [N1*N2*N3 M1*M2*M3], 'T32contract' );

for i=1:size(T22,1)
    for j=1:size(T22,2)
        T22{i,j}=operator_from_matrix(T22{i,j});
    end
end
assert_equals ( tensor_operator_size( T22 ), [N1 M1; N2 M2], 'T22op' );


