function unittest_schattenp_truncate
% UNITTEST_TENSOR_TRUNCATE Test the TENSOR_TRUNCATE function.
%
% Example (<a href="matlab:run_example unittest_tensor_truncate">run</a>)
%    unittest_tensor_truncate
%
% See also TENSOR_TRUNCATE, TESTSUITE

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



munit_set_function( 'schattenp_truncate' );

s=[5,4,3,2,1];
assert_equals( schattenp_truncate( s, 6, false, inf ), 0 );
assert_equals( schattenp_truncate( s, 5, false, inf ), 1 );
assert_equals( schattenp_truncate( s, 4.5, false, inf ), 1 );
assert_equals( schattenp_truncate( s, 4, false, inf ), 2 );
assert_equals( schattenp_truncate( s, 1.5, false, inf ), 4 );
assert_equals( schattenp_truncate( s, 0.5, false, inf ), 5 );
assert_equals( schattenp_truncate( s, 0, false, inf ), 5 );

assert_equals( schattenp_truncate( s, 4, false, 2 ), 2 );
assert_equals( schattenp_truncate( s, sqrt(5), false, 2 ), 3 );
assert_equals( schattenp_truncate( s, 2, false, 2 ), 4 );
assert_equals( schattenp_truncate( s, 1, false, 2 ), 4 );
assert_equals( schattenp_truncate( s, 0, false, 2 ), 5 );

assert_equals( schattenp_truncate( s, 4, false, 1 ), 3 );
assert_equals( schattenp_truncate( s, 3, false, 1 ), 3 );
assert_equals( schattenp_truncate( s, 2.5, false, 1 ), 4 );
