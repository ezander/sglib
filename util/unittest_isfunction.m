function unittest_isfunction
% UNITTEST_ISFUNCTION Test the ISFUNCTION function.
%
% Example (<a href="matlab:run_example unittest_isfunction">run</a>)
%   unittest_isfunction
%
% See also ISFUNCTION, MUNIT_RUN_TESTSUITE 

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

munit_set_function( 'isfunction' );

assert_true( isfunction('eval'), '''eval'' is a function', 'char' );
assert_true( isfunction(@(a)(a)), 'anon is a function', 'anon' );
assert_true( isfunction(@min), 'handle is a function', 'handle' );
assert_false( isfunction(17), 'number is not a function', 'number' );
assert_true( isfunction(inline('x','x*x')), 'inline def is a function', 'inline' );
assert_true( isfunction({'eval'}), '{''eval''} is a function', 'cell' );
assert_true( isfunction({@min}), '{handle} is a function', 'cell_handle' );


