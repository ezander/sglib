function unittest_refine_mesh
% UNITTEST_REFINE_MESH Test the REFINE_MESH function.
%
% Example (<a href="matlab:run_example unittest_refine_mesh">run</a>)
%   unittest_refine_mesh
%
% See also REFINE_MESH, TESTSUITE 

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

munit_set_function( 'refine_mesh' );

% This unit test is bad since it relies on a specific ordering of the new
% nodes, however doing it right (i.e. checking only necessary geometric
% properties of the new mesh) is too complicated to pay off. So: if this
% test fails, check by hand and if its a correct reordering then correct
% the test!
[np,ne]=refine_mesh( [-2 0; 0 4; 2 0]', [1 2 3]' );
assert_equals( np, [-2 0; 0 4; 2 0; -1 2; 0 0; 1 2]', 'new_pos' );
assert_equals( order_els(ne), order_els([6 4 5; 2 4 6; 6 5 3; 4 1 5]'), 'new_el' );

% check that new points are unique
pos=[0, 1, 1, 0; 0, 0, 1, 1];
els=[1,3;2,4;3,1];
[np,ne]=refine_mesh( pos, els );
npu=unique(np','rows')';
assert_equals( size(np), size(npu), 'unique_pos' );
% clf
% plot_mesh( pos, els, 'color', 'k'  );
% plot_boundary( pos, els, 'color', 'r'  );
% clf
% plot_mesh( np, ne, 'color', 'k'  );
% plot_boundary( np, ne, 'color', 'r'  );



% This defines a mesh in the shape of a butterfly, refining it with e.g.
% delaunay gives points outside the boundary and connects points that
% should not be connected (i.e. points that are very close but not
% connected in the original mesh). This test only checks it graphically, 
% since I had no time to correctly code the test algorithmically)
% pos=[-1 3; 0 0; 1 3; 1 -3; -1 -3]';
% els=[1 5 2; 2 4 3]';
% clf
% plot_mesh( pos, els, 'color', 'k'  );
% plot_boundary( pos, els, 'color', 'r'  );
% [npos,nels]=refine_mesh( pos, els );
% plot_mesh( npos, nels, 'color', 'k'  );
% plot_boundary( npos, nels, 'color', 'b'  );
% xlim([-2,2]);
% ylim([-4,4]);


function els=order_els(els)
els=sortrows( sort( els, 1 )' )';
