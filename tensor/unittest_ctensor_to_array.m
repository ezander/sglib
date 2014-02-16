function unittest_ctensor_to_array
% UNITTEST_CTENSOR_TO_ARRAY Test the CTENSOR_TO_ARRAY function.
%
% Example (<a href="matlab:run_example unittest_ctensor_to_array">run</a>)
%   unittest_ctensor_to_array
%
% See also CTENSOR_TO_ARRAY, MUNIT_RUN_TESTSUITE 

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

munit_set_function( 'ctensor_to_array' );

T2={rand(5,3), rand(7,3)};
v=ctensor_to_array(T2);
assert_equals( v, T2{1}*T2{2}', 'order2' );

u1=rand(5,2); u2=rand(7,2); u3=rand(9,2);
T3={u1, u2, u3};
v=ctensor_to_array(T3);
v_ex=repmat( reshape( u1(:,1), [5,1,1]), [1,7,9] ).*...
    repmat( reshape( u2(:,1), [1,7,1]), [5,1,9] ).*...
    repmat( reshape( u3(:,1), [1,1,9]), [5,7,1] )+...
    repmat( reshape( u1(:,2), [5,1,1]), [1,7,9] ).*...
    repmat( reshape( u2(:,2), [1,7,1]), [5,1,9] ).*...
    repmat( reshape( u3(:,2), [1,1,9]), [5,7,1] );
assert_equals( v, v_ex, 'order3' );

