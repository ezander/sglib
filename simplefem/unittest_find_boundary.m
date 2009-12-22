function unittest_find_boundary
% UNITTEST_FIND_BOUNDARY Test the FIND_BOUNDARY function.
%
% Example (<a href="matlab:run_example unittest_find_boundary">run</a>)
%   unittest_find_boundary
%
% See also FIND_BOUNDARY, TESTSUITE 

%   Elmar Zander
%   Copyright 2009, Inst. of Scientific Comuting
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'find_boundary' );

[els,pos,bnd]=create_mesh_1d( 5, 0, 2);
assert_equals( find_boundary( els ), [1;5], '1d' );

