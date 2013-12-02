function unittest_create_mesh_2d_rect
% UNITTEST_CREATE_MESH_2D_RECT Test the CREATE_MESH_2D_RECT function.
%
% Example (<a href="matlab:run_example unittest_create_mesh_2d_rect">run</a>)
%   unittest_create_mesh_2d_rect
%
% See also CREATE_MESH_2D_RECT

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

munit_set_function( 'create_mesh_2d_rect' );

% Check sizes
for i = 1:5
    [pos,els]=create_mesh_2d_rect(i);
    assert_equals(size(pos), [2, (2^i+1)^2], sprintf('size_pos_%d', i));
    assert_equals(size(els), [3, 2^(2*i+1)], sprintf('size_els_%d', i));
end

% check for one mesh with 4 refinements
n=4;
pos=create_mesh_2d_rect(n);
k=2^n;
% this checks that truly all points are contained by mapping them uniquely
% to the integers
assert_equals(sort(round([k, k*(k+1)] * pos)), 0:((k+1)^2-1), 'unique_points');

% check default (currently 3 refinements)
pos=create_mesh_2d_rect();
assert_equals(size(pos), [2, 81], 'default');
