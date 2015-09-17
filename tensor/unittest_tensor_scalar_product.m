function unittest_tensor_scalar_product
% UNITTEST_TENSOR_SCALAR_PRODUCT Test the TENSOR_SCALAR_PRODUCT functions.
%
% Example (<a href="matlab:run_example unittest_tensor_scalar_product">run</a>)
%    unittest_tensor_scalar_product
%
% See also TESTSUITE

%   Elmar Zander
%   Copyright 2007-2014, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'tensor_scalar_product' );
 
v1=rand(10,1);
v2=rand(10,1);
assert_equals( tensor_scalar_product(v1,v2), v1'*v2, 'vec' );


T1={rand(8,4), rand(10,4) };
T2={rand(8,3), rand(10,3) };
M1=rand(8); M1=M1*M1';
M2=rand(10); M2=M2*M2';
t1=ctensor_to_vector(T1);
t2=ctensor_to_vector(T2);
s=tensor_scalar_product(T1,T2);
assert_equals( s, t1'*t2, 'inner' );
s=tensor_scalar_product(T1,T2,{M1,[]});
assert_equals( s, t1'*revkron(M1,eye(size(M2)))*t2, 'inner_M1' );
s=tensor_scalar_product(T1,T2,{[],M2});
assert_equals( s, t1'*revkron(eye(size(M1)),M2)*t2, 'inner_M2' );
s=tensor_scalar_product(T1,T2,{M1,M2});
assert_equals( s, t1'*revkron(M1,M2)*t2, 'inner_M1_M2' );



T1=ctensor_to_array(T1);
T2=ctensor_to_array(T2);
s=tensor_scalar_product(T1,T2,{M1,M2});
assert_equals( s, t1'*revkron(M1,M2)*t2, 'inner_M1_M2_2' );

