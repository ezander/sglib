function unittest_combine_options(varargin)
% UNITTEST_COMBINE_OPTIONS Test the COMBINE_OPTIONS function.
%
% Example (<a href="matlab:run_example unittest_combine_options">run</a>)
%   unittest_combine_options
%
% See also COMBINE_OPTIONS, MUNIT_RUN_TESTSUITE 

%   Elmar Zander
%   Copyright 2016, Institute of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'combine_options' );

%%
opts1 = {'foo', 1, 'bar', 2};
opts2 = {'foo', 3, 'baz', 4};
opts_ex.foo = 3;
opts_ex.bar = 2;
opts_ex.baz = 4;


opts = combine_options(opts1, opts2);
assert_equals(opts, opts_ex, 'cell_cell');
