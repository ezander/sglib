function unittest_strvarexpand
% UNITTEST_STRVAREXPAND Test the STRVAREXPAND function.
%
% Example (<a href="matlab:run_example unittest_strvarexpand">run</a>)
%   unittest_strvarexpand
%
% See also STRVAREXPAND, MUNIT_RUN_TESTSUITE 

%   Elmar Zander
%   Copyright 2009, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'strvarexpand' );

% define some variables for testing
a=10; %#ok
cell={10,'abc'}; %#ok
test='1234'; %#ok

% test basic expressions
assert_equals( strvarexpand(''), '', 'empty' );
assert_equals( strvarexpand('foo'), 'foo', 'str' );
assert_equals( strvarexpand('$test$'), '1234', 'var' );
assert_equals( strvarexpand('$a$'), '10', 'numvar' );
assert_equals( strvarexpand('$a^2$'), '100', 'expr1' );
assert_equals( strvarexpand('$length(cell)$'), '2', 'expr2' );
assert_equals( strvarexpand('XX$a$'), 'XX10', 'mixed1' );
assert_equals( strvarexpand('$a$YY'), '10YY', 'mixed2' );
assert_equals( strvarexpand('a+1=$a+1$ cell={$cell{1}$,$cell{2}$} test=$test$'), 'a+1=11 cell={10,abc} test=1234', 'mixed3' );

% test arrays and cells
assert_equals( strvarexpand('$[1+1,2*3]$'), '[2, 6]', 'arr' );
assert_equals( strvarexpand('${''abc'',2^3}$'), '{abc, 8}', 'cell1' );
assert_equals( strvarexpand('$cell$'), '{10, abc}', 'cell2' );

% test logical values and logical arrays
assert_equals( strvarexpand('$true$'), '1', 'logical_t' );
assert_equals( strvarexpand('$false$'), '0', 'logical_f' );
assert_equals( strvarexpand('$[true,false,true]$'), '[1, 0, 1]', 'logical_arr' );

% test structs
s=struct();
s.a=a;
s.cell=cell;
assert_equals( strvarexpand('$struct()$'), '()', 'struct_empty' );
assert_equals( strvarexpand('$s$'), '(a=10, cell={10, abc})', 'struct' );

% test errorneous constructs
assert_equals( strvarexpand('$not_defined$'), '<err:not_defined>', 'err' );
assert_equals( strvarexpand('$xxx$'), '<err:xxx>', 'err' );

% test escaped $'s
assert_equals( strvarexpand('\$xxx\$'), '$xxx$', 'escaped' );
assert_equals( strvarexpand('$1+2$ \$x\axx\$ $1+1$ \b \$'), '3 $x\axx$ 2 \b $', 'escaped2' );

% test optional parameters
assert_equals( strvarexpand('$[1,2,3,4,5]$', 'maxarr', 2), '[1, 2, ...]', 'maxarr2' );
assert_equals( strvarexpand('$[1,2,3,4,5]$', 'maxarr', 3), '[1, 2, 3, ...]', 'maxarr3' );
assert_equals( strvarexpand('${1,2,3,4,5}$', 'maxcell', 2), '{1, 2, ...}', 'maxcell2' );
assert_equals( strvarexpand('${1,2,3,4,5}$', 'maxcell', 4), '{1, 2, 3, 4, ...}', 'maxcell4' );

% Test with quote
assert_equals( strvarexpand('$test$', 'quotes', false), '1234', 'noquotes' );
assert_equals( strvarexpand('$test$', 'quotes', true), '''1234''', 'quotes' );
