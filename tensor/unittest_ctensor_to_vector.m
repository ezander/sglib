function unittest_ctensor_to_vector
% UNITTEST_CTENSOR_TO_VECTOR Test the CTENSOR_TO_VECTOR function.
%
% Example (<a href="matlab:run_example unittest_ctensor_to_vector">run</a>)
%   unittest_ctensor_to_vector
%
% See also CTENSOR_TO_VECTOR, MUNIT_RUN_TESTSUITE 

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

munit_set_function( 'ctensor_to_vector' );

T2={rand(5,3), rand(7,3)};
v=ctensor_to_vector(T2);
v_ex=reshape( (T2{1}*T2{2}'), [], 1);
assert_equals( v, v_ex, 'order2' );

T3={rand(5,2), rand(7,2), rand(9,2)};
v=ctensor_to_vector(T3);
v1=revkron( T3{1}(:,1), revkron( T3{2}(:,1), T3{3}(:,1) ) );
v2=revkron( T3{1}(:,2), revkron( T3{2}(:,2), T3{3}(:,2) ) );
assert_equals( v, v1+v2, 'order3' );

