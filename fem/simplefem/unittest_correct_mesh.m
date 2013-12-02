function unittest_correct_mesh
% UNITTEST_CORRECT_MESH Test the CORRECT_MESH function.
%
% Example (<a href="matlab:run_example unittest_correct_mesh">run</a>)
%   unittest_correct_mesh
%
% See also CORRECT_MESH

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

munit_set_function( 'correct_mesh' );

% 1d mesh where no change is necessary
[pos1,els1]=create_mesh_1d( 2, 5, 10 );
[pos2,els2]=correct_mesh( pos1, els1 );
assert_equals( pos1, pos2, 'no_change1' );
assert_equals( els1, els2, 'no_change2' );

% add some unused nodes that need to be removed
els3=els1+5;
pos3=[zeros(1,5), pos1, ones(1,3)];
[pos2,els2]=correct_mesh( pos3, els3 );
assert_equals( pos1, pos2, 'rem_points1' );
assert_equals( els1, els2, 'rem_points2' );

% swap some indices in els so that the determinant becomes negative
els3=els1;
ind=[1,3,7];
els3([1,2],ind)=els3([2,1],ind);
pos3=pos1;
[pos2,els2]=correct_mesh( pos3, els3 );
assert_equals( pos1, pos2, 'invert1' );
assert_equals( els1, els2, 'invert2' );

% 2D test for the following grid
%  1
% 234
%  5
els=[1 2 3; 1 3 4; 2 3 5; 3 4 5]';
pos=[0 1; -1 0; 0 0; 1 0; 0 -1]';
[pos2,els2]=correct_mesh( pos, els );
assert_equals( pos2, pos, '2d_pos' );
assert_equals( els2, [1 2 3; 1 3 4; 3 2 5; 4 3 5]', '2d_els' );
