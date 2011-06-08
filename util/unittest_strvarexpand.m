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
s.a=a;
s.cell=cell;

assert_equals( strvarexpand(''), '', 'empty' );
assert_equals( strvarexpand('foo'), 'foo', 'str' );
assert_equals( strvarexpand('$test$'), '1234', 'var' );
assert_equals( strvarexpand('$a$'), '10', 'numvar' );
assert_equals( strvarexpand('$a^2$'), '100', 'expr1' );
assert_equals( strvarexpand('$length(cell)$'), '2', 'expr2' );
assert_equals( strvarexpand('XX$a$'), 'XX10', 'mixed1' );
assert_equals( strvarexpand('$a$YY'), '10YY', 'mixed2' );
assert_equals( strvarexpand('a+1=$a+1$ cell={$cell{1}$,$cell{2}$} test=$test$'), 'a+1=11 cell={10,abc} test=1234', 'mixed3' );

assert_equals( strvarexpand('$[1+1,2*3]$'), '[2, 6]', 'arr' );
assert_equals( strvarexpand('${''abc'',2^3}$'), '{abc, 8}', 'cell1' );
assert_equals( strvarexpand('$cell$'), '{10, abc}', 'cell2' );

assert_equals( strvarexpand('$true$'), '1', 'logical_t' );
assert_equals( strvarexpand('$false$'), '0', 'logical_f' );
assert_equals( strvarexpand('$[true,false,true]$'), '[1, 0, 1]', 'logical_arr' );


assert_equals( strvarexpand('$struct()$'), '()', 'struct_empty' );
assert_equals( strvarexpand('$s$'), '(a=10, cell={10, abc})', 'struct' );


assert_equals( strvarexpand('$not_defined$'), '<err:not_defined>', 'err' );
assert_equals( strvarexpand('$xxx$'), '<err:xxx>', 'err' );


% warning( 'off', 'strvarexpand:type' );
% assert_equals( strvarexpand('$struct()$'), '$struct()$', 'struct_fail' );
% warning( 'on', 'strvarexpand:type' );
