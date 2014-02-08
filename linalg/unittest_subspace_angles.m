function unittest_subspace_angles
% UNITTEST_SUBSPACE_ANGLES Test the SUBSPACE_ANGLES function.
%
% Example (<a href="matlab:run_example unittest_subspace_angles">run</a>)
%   unittest_subspace_angle
%
% See also SUBSPACE_ANGLES, MUNIT_RUN_TESTSUITE 

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

munit_set_function( 'subspace_angles' );

e1=unitvector(1,4);
e2=unitvector(2,4);
e3=unitvector(3,4);
e4=unitvector(4,4);

test([e1, e2], [e1, e2]);
test([e1, e2], [e1, e3]);
test([e1, e2], [e3, e4]);
test([e1, e2], [e1, -e2+e4]);

A=rand(7,5); B=rand(7,5); 
assert_equals( asin(subspace_distance(A,B)), subspace(A,B) )
A=[A, A]; B=[B, B];
assert_equals( asin(subspace_distance(A,B)), subspace(A,B) )
A=rand(7,5); B=rand(7,3); 
assert_equals( asin(subspace_distance(A,B)), subspace(A,B) )
A=rand(7,3); B=rand(7,5); 
assert_equals( asin(subspace_distance(A,B)), subspace(A,B) )


function test(A1,A2)
theta=subspace_angles(A1,A2);
dist=subspace_distance(A1,A2);
assert_equals( dist, sin(theta(2)) );
