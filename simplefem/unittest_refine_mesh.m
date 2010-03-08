function unittest_refine_mesh
% UNITTEST_REFINE_MESH Test the REFINE_MESH function.
%
% Example (<a href="matlab:run_example unittest_refine_mesh">run</a>)
%   unittest_refine_mesh
%
% See also REFINE_MESH, TESTSUITE 

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

munit_set_function( 'refine_mesh' );

[np,ne]=refine_mesh( [-2 0; 0 4; 2 0]', [1 2 3]' );
assert_equals( np, [-2 0; 0 4; 2 0; -1 2; 1 2; 0 0]', 'new_pos' );
assert_equals( order_els(ne), order_els([5 4 6; 2 4 5; 5 6 3; 4 1 6]'), 'new_el' );


function els=order_els(els)
els=sortrows( sort( els, 1 )' )';
