function unittest_create_mesh_1d
% UNITTEST_CREATE_MESH_1D Test the CREATE_MESH_1D function.
%
% Example (<a href="matlab:run_example unittest_create_mesh_1d">run</a>)
%   unittest_create_mesh_1d
%
% See also CREATE_MESH_1D

%   Elmar Zander
%   Copyright 2010, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'create_mesh_1d' );

% ordered nodes
[pos,els,bnd]=create_mesh_1d( -1.2, 3.5, 17 );
h=4.7/16;
assert_equals( min(pos), -1.2, 'left' );
assert_equals( max(pos), 3.5, 'right' );
assert_equals( size(pos), [1,17], 'size_pos' );
assert_equals( sort(pos(bnd)), [-1.2, 3.5], 'bnd' );
assert_equals( size(els), [2,16], 'size_els' );
assert_equals( pos(els(2,:))-pos(els(1,:)), h*ones(1,16), 'all_h' );

% shuffled nodes
[pos,els,bnd]=create_mesh_1d( -1.2, 3.5, 17, true );
h=4.7/16;
assert_equals( min(pos), -1.2, 'left' );
assert_equals( max(pos), 3.5, 'right' );
assert_equals( size(pos), [1,17], 'size_pos' );
assert_equals( sort(pos(bnd)), [-1.2, 3.5], 'bnd' );
assert_equals( size(els), [2,16], 'size_els' );
assert_equals( pos(els(2,:))-pos(els(1,:)), h*ones(1,16), 'all_h' );
