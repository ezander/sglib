function unittest_strvarexpand
% UNITTEST_STRVAREXPAND Test the STRVAREXPAND function.
%
% Example (<a href="matlab:run_example unittest_strvarexpand">run</a>)
%   unittest_strvarexpand
%
% See also STRVAREXPAND, TESTSUITE 

%   Elmar Zander
%   Copyright 2009, Inst. of Scientific Computing, TU Braunschweig
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'strvarexpand' );

a=10; %#ok
cell={10,'abc'}; %#ok
test='1234'; %#ok

assert_equals( strvarexpand(''), '', 'empty' );
assert_equals( strvarexpand('foo'), 'foo', 'str' );
assert_equals( strvarexpand('$test$'), '1234', 'var' );
assert_equals( strvarexpand('$a$'), '10', 'numvar' );
assert_equals( strvarexpand('$a^2$'), '100', 'expr1' );
assert_equals( strvarexpand('$length(cell)$'), '2', 'expr2' );
assert_equals( strvarexpand('XX$a$'), 'XX10', 'mixed1' );
assert_equals( strvarexpand('$a$YY'), '10YY', 'mixed2' );
assert_equals( strvarexpand('a+1=$a+1$ cell={$cell{1}$,$cell{2}$} test=$test$'), 'a+1=11 cell={10,abc} test=1234', 'mixed3' );


