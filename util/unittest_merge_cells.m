function test_merge_cells
% TEST_MERGE_CELLS Test the MERGE_CELLS function.
%
% Example (<a href="matlab:run_example test_merge_cells">run</a>) 
%    test_merge_cells
%
% See also TESTSUITE, MERGE_CELLS

%   Elmar Zander
%   Copyright 2009, Institute of Scientific Computing, TU Braunschweig.
%   $Id: test_merge_cells.m 96 2009-06-03 14:22:20Z ezander $ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


assert_set_function( 'merge_cells' );

% test parameter placement
assert_equals( merge_cells( {'a','b'}, {2,4}, {'c','d','e'}), {'c', 'a', 'd', 'b', 'e' }, 'mm' );
assert_equals( merge_cells( {'a'}, {2}, {'c','d','e'}), {'c', 'a', 'd', 'e' }, 'sm' );
assert_equals( merge_cells( {}, {}, {'c','d','e'}), {'c', 'd', 'e' }, 'em' );
assert_equals( merge_cells( {'a','b'}, {2,1}, {} ), {'b', 'a'}, 'me' );
assert_equals( merge_cells( {'a','b'}, {2,1}, {'c'} ), {'b', 'a', 'c'}, 'ms' );
assert_equals( merge_cells( {}, {}, {} ), cell(1,0), 'ee' );
