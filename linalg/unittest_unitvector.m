function unittest_unitvector
% UNITTEST_UNITVECTOR Test the UNITVECTOR function.
%
% Example (<a href="matlab:run_example unittest_unitvector">run</a>)
%   unittest_unitvector
%
% See also UNITVECTOR, MUNIT_RUN_TESTSUITE 

%   Elmar Zander
%   Copyright 2010, Inst. of Scientific Computing
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'unitvector' );

assert_equals( unitvector( 3, 5 ), [0,0,1,0,0]', 'single' );

assert_equals( unitvector( [1,2,4], 5 ), [1,0,0;0,1,0;0,0,0;0,0,1;0,0,0], 'multi' );
assert_false( issparse(unitvector( [1,2,4], 5 ) ), 'result should be a full matrix', 'full' );

assert_equals( unitvector( [1,2,4], 5, true ), [1,0,0;0,1,0;0,0,0;0,0,1;0,0,0], 'sparseres' );
assert_true( issparse(unitvector( [1,2,4], 5, true ) ), 'result should be a sparse matrix', 'sparse' );

assert_equals( unitvector( [1,2,4] ), [1,0,0;0,1,0;0,0,0;0,0,1], 'multi_one_arg' );
