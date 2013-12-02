function unittest_row_col_mult
% UNITTEST_ROW_COL_MULT Test row_col_mult function.
%
% Example (<a href="matlab:run_example unittest_row_col_mult">run</a>)
%    unittest_row_col_mult
%
% See also TESTSUITE

%   Elmar Zander
%   Copyright 2007, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


munit_set_function( 'unittest_row_col_mult' );
assert_equals( row_col_mult([1 2; 3 4], [1, 2]), [1 4; 3 8], 'row_mult' );
assert_equals( row_col_mult([1 2; 3 4], [1; 2]), [1 2; 6 8], 'col_mult' );
assert_false( issparse( row_col_mult([1 2; 3 4], [1, 2])), [], 'full' );
assert_false( issparse( row_col_mult([1 2; 3 4], [1; 2])), [], 'full' );
assert_false( issparse( row_col_mult([1 2 3 4], 1)), [], 'full' );
assert_false( issparse( row_col_mult([1; 2; 3; 4], 1)), [], 'full' );

assert_equals( row_col_mult(sparse([1 2; 3 4]), [1, 2]), [1 4; 3 8], 'row_mult_sp' );
assert_equals( row_col_mult(sparse([1 2; 3 4]), [1; 2]), [1 2; 6 8], 'col_mult_sp' );
assert_true( issparse( row_col_mult(sparse([1 2; 3 4]), [1; 2])), [], 'sparse' );
assert_true( issparse( row_col_mult(sparse([1 2; 3 4]), 1)), [], 'sparse' );

assert_error( {@row_col_mult,{[1 2; 3 4], [1, 2; 2,  3]},{1,2}}, 'util:row_col_mult:', 'no_vector' )

