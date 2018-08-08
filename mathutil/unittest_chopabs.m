function unittest_chopabs
% UNITTEST_CHOPABS Test the CHOPABS function.
%
% Example (<a href="matlab:run_example unittest_chopabs">run</a>)
%    unittest_chopabs
%
% See also TESTSUITE, CHOPABS

%   Elmar Zander
%   Copyright 2009, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


munit_set_function( 'chopabs' );

A=[ 1 2 1e-11 1e-3 3];
assert_equals( chopabs(A), [1, 2, 0, 1e-3, 3], 'oneparam' );
assert_equals( chopabs(A,1e-2), [1, 2, 0, 0, 3], 'twoparam1' );
assert_equals( chopabs(A,1e-12), A, 'twoparam2' );


A=[ 1 2 5+1e-11i 1e-3 3];
assert_equals( chopabs(A), [1, 2, 5, 1e-3, 3], 'complex_oneparam', 'reltol', 0, 'abstol', 0 );
assert_equals( chopabs(A, 1e-12), A, 'complex_twoparam', 'reltol', 0, 'abstol', 0 );
