function unittest_correct_mesh
% UNITTEST_CORRECT_MESH Test the CORRECT_MESH function.
%
% Example (<a href="matlab:run_example unittest_correct_mesh">run</a>)
%   unittest_correct_mesh
%
% See also CORRECT_MESH, TESTSUITE 

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

munit_set_function( 'correct_mesh' );

[els1,pos1]=create_mesh_1d( 10, 2, 5 );
[els2,pos2]=correct_mesh( els1, pos1 );
assert_equals( els1, els2, 'no_change1' );
assert_equals( pos1, pos2, 'no_change2' );

els3=els1+5;
pos3=[zeros(5,1); pos1; ones(3,1)];
[els2,pos2]=correct_mesh( els3, pos3 );
assert_equals( els1, els2, 'rem_points1' );
assert_equals( pos1, pos2, 'rem_points2' );

els3=els1;
ind=[1,3,7];
els3(ind,[1,2])=els3(ind,[2,1]);
pos3=pos1;
[els2,pos2]=correct_mesh( els3, pos3 );
assert_equals( els1, els2, 'invert1' );
assert_equals( pos1, pos2, 'invert2' );

% 2D test for the following grid
%  1
% 234
%  5
els=[1 2 3; 1 3 4; 2 3 5; 3 4 5];
pos=[0 1; -1 0; 0 0; 1 0; 0 -1];
[els2,pos2]=correct_mesh( els, pos );
assert_equals( els2, [1 2 3; 1 3 4; 3 2 5; 4 3 5], '2d_els' );
assert_equals( pos2, pos, '2d_pos' );



assert_error( '', '2d_pos' );

