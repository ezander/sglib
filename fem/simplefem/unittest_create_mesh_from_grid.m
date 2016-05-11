function unittest_create_mesh_1d
% UNITTEST_CREATE_MESH_FROM_GRID Test the CREATE_MESH_FROM_GRID function.
%
% Example (<a href="matlab:run_example unittest_create_mesh_from_grid">run</a>)
%   unittest_create_mesh_from_grid
%
% See also CREATE_MESH_FROM_GRID, MUNIT_RUN_TESTSUITE 

%   Elmar Zander
%   Copyright 2016, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'create_mesh_from_grid' );


vx = linspace(0, 2, 10);
vy = linspace(1, 3, 11);
[X,Y] = meshgrid(vx,vy);

[pos,els]=create_mesh_from_grid(X,Y);
assert_equals(pos(1,:), X(:)', 'xpos')
assert_equals(pos(2,:), Y(:)', 'ypos')
assert_equals(els(:,1),   1    +[0;11;1], 'els1');
assert_equals(els(:,end), 11*10-[1;0;11], 'els2');

[posv,elsv]=create_mesh_from_grid(vx,vy);
assert_equals(posv, pos, 'posv');
assert_equals(elsv, els, 'elsv');

[posv,elsv]=create_mesh_from_grid(1:5,1:3);
[posn,elsn]=create_mesh_from_grid(5,3);
assert_equals(posn, posv, 'posn');
assert_equals(elsn, elsv, 'elsn');
