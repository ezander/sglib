function unittest_funcall_funfun
% UNITTEST_FUNCALL_FUNFUN Test the FUNCALL_FUNFUN function.
%
% Example (<a href="matlab:run_example unittest_funcall_funfun">run</a>)
%   unittest_funcall_funfun
%
% See also FUNCALL_FUNFUN, MUNIT_RUN_TESTSUITE 

%   Elmar Zander
%   Copyright 2009, Inst. of Scientific Computing
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'funcall_funfun' );

assert_equals( funcall_funfun( 3, 4, 'times' ), 12, 'char' );
assert_equals( funcall_funfun( 4, {'times', {3}} ), 12, 'cell' );


