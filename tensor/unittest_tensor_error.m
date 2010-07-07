function unittest_tensor_error
% UNITTEST_TENSOR_ERROR Test the TENSOR_ERROR function.
%
% Example (<a href="matlab:run_example unittest_tensor_error">run</a>)
%   unittest_tensor_error
%
% See also TENSOR_ERROR, TESTSUITE 

%   Elmar Zander
%   Copyright 2010, Inst. of Scientific Computing, TU Braunschweig
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'tensor_error' );

TA={rand(4,2), rand(5,2)};
DT={rand(4,1), rand(5,1)};
TE=tensor_add( TA, DT );
L1=rand(4,4);
L2=rand(5,5);
G={L1*L1', L2*L2'};
assert_equals( tensor_error(TA, TE), tensor_norm(DT), 'canon' );
assert_equals( tensor_error(TA, TE, 'G', G), tensor_norm(DT, G), 'canonG' );

%
M=53;
N=47;
R=13;
randn('seed', 1018663534 );
%format short g
for d=10.^(-3:-1:-10)
    T1=create_test_tensor( M, N, R );
    T2=perturb_test_tensor( T1, d );
    T1mat=tensor_to_array(T1);
    T2mat=tensor_to_array(T2);
    assert_equals( tensor_error( T1, T2 ), gvector_error( T1mat, T2mat ), 'small_err', 'abstol', 1e-14 );
end
