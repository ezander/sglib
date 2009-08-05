function test_utils
% TEST_UTILS Test utils related functions.
%
% Example (<a href="matlab:run_example test_utils">run</a>) 
%    test_utils
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

assert_set_function( 'utils/merge_cells' );

assert_equals( merge_cells({'a','b'},{1,2},{'c'}), {'a','b','c'}, 'merge_pos1' );
assert_equals( merge_cells({'a','b'},{1,3},{'c'}), {'a','c','b'}, 'merge_pos2' );
assert_equals( merge_cells({'a','b'},{2,3},{'c'}), {'c','a','b'}, 'merge_pos3' );
assert_equals( merge_cells({'a','b'},{2,1},{'c'}), {'b','a','c'}, 'merge_pos4' );
assert_equals( merge_cells({'a','b'},{3,1},{'c'}), {'b','c','a'}, 'merge_pos5' );
assert_equals( merge_cells({'a','b'},{3,2},{'c'}), {'c','b','a'}, 'merge_pos6' );


assert_set_function( 'utils/funcall' );

assert_equals( funcall( {@power,{3}},2 ), 8, 'nopos' );
assert_equals( funcall( {@(y,x)(power(x,y)),{3}},2 ), 9, 'anon' );
assert_equals( funcall( {@power,{3},{2}},2 ), 8, 'pos2' );
assert_equals( funcall( {@power,{3},{1}},2 ), 9, 'pos1' );

assert_set_function( 'utils/ismatlab' );
ismat=ismatlab();
isoct=isoctave();
assert_true( ismat~=isoct, 'notboth' );


% a second test for matlab/octave
dir_list  = lower(path);
isoctave_ex = (length( findstr(dir_list, 'octave') )>0);
ismatlab_ex = (length( findstr(dir_list, 'matlab') )>0);

assert_equals( isoct, isoctave_ex, 'second_check_oct' ); 
assert_equals( ismat, ismatlab_ex, 'second_check_oct' ); 

