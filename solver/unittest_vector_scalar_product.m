function unittest_vector_scalar_product
% UNITTEST_VECTOR_SCALAR_PRODUCT Test the VECTOR functions.
%
% Example (<a href="matlab:run_example unittest_vector_scalar_product">run</a>)
%    unittest_vector_scalar_product
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

munit_set_function( 'vector_scalar_product' );
 
v1=rand(10,1);
v2=rand(10,1);
assert_equals( vector_scalar_product(v1,v2), v1'*v2, 'vec' );


T1={rand(8,4), rand(10,4) };
T2={rand(8,3), rand(10,3) };
M1=rand(8); M1=M1*M1';
M2=rand(10); M2=M2*M2';
t1=reshape(T1{1}*T1{2}',[],1);
t2=reshape(T2{1}*T2{2}',[],1);
s=vector_scalar_product(T1,T2);
assert_equals( s, t1'*t2, 'inner' );
s=vector_scalar_product(T1,T2,{M1,[]});
assert_equals( s, t1'*revkron(M1,eye(size(M2)))*t2, 'inner_M1' );
s=vector_scalar_product(T1,T2,{[],M2});
assert_equals( s, t1'*revkron(eye(size(M1)),M2)*t2, 'inner_M2' );
s=vector_scalar_product(T1,T2,{M1,M2});
assert_equals( s, t1'*revkron(M1,M2)*t2, 'inner_M1_M2' );

