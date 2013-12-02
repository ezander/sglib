function unittest_mesh_parameters
% UNITTEST_MESH_PARAMETERS Test the MESH_PARAMETERS function.
%
% Example (<a href="matlab:run_example unittest_mesh_parameters">run</a>)
%   unittest_mesh_parameters
%
% See also MESH_PARAMETERS

%   Elmar Zander
%   Copyright 2013, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'mesh_parameters' );


[pos, els] = create_mesh_2d_rect(0);
[hmin, hmax, hmean, qual]=mesh_parameters( pos, els );

assert_equals(hmin, 1, 'hmin1');
assert_equals(hmax, sqrt(2), 'hmax1');
assert_equals(hmean, (2+sqrt(2))/3, 'hmean1');
assert_equals(qual, [1,1]*sqrt(2)/(1-sqrt(0.5)), 'qual');
