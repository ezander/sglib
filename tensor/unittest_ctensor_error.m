function unittest_ctensor_error
% UNITTEST_CTENSOR_ERROR Test the CTENSOR_ERROR function.
%
% Example (<a href="matlab:run_example unittest_ctensor_error">run</a>)
%   unittest_ctensor_error
%
% See also CTENSOR_ERROR, MUNIT_RUN_TESTSUITE 

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

munit_set_function( 'ctensor_error' );

munit_control_rand('seed');

TA={rand(4,2), rand(5,2)};
DT={rand(4,1), rand(5,1)};
TE=ctensor_add( TA, DT );
L1=rand(4,4);
L2=rand(5,5);
G={L1*L1', L2*L2'};
assert_equals( ctensor_error(TA, TE), ctensor_norm(DT), 'canon' );
assert_equals( ctensor_error(TA, TE, 'G', G), ctensor_norm(DT, G), 'canonG' );

%
M=53;
N=47;
R=13;
munit_control_rand('seed', 1018663534 );
%format short g
for d=10.^(-3:-1:-10)
    T1=create_test_tensor( M, N, R );
    T2=perturb_test_ctensor( T1, d );
    T1mat=ctensor_to_array(T1);
    T2mat=ctensor_to_array(T2);
    assert_equals( ctensor_error( T1, T2 ), tensor_error( T1mat, T2mat ), 'small_err', 'abstol', 1e-14 );
end
