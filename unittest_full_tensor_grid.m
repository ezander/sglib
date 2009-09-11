function unittest_full_tensor_grid
% UNITTEST_FULL_TENSOR_GRID Test the FULL_TENSOR_GRID function.
%
% Example (<a href="matlab:run_example unittest_full_tensor_grid">run</a>)
%   unittest_full_tensor_grid
%
% See also FULL_TENSOR_GRID, TESTSUITE 

%   Elmar Zander
%   Copyright 2009, Inst. of Scientific Computing, TU Braunschweig
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

assert_set_function( 'full_tensor_grid' );


% test 1: dummy in dim 1 should give the same as the rule itself
[xd,wd]=full_tensor_grid( 1, 5, @dummy_rule );
[x5,w5]=dummy_rule(5);
assert_equals( xd, x5, 'xd_1' );
assert_equals( wd, w5, 'wd_1' );

% test 2: dummy in dim 2 with same stages
[xd,wd]=full_tensor_grid( 2, 5, @dummy_rule );
assert_equals( sum(xd,2), [0;0], 'sum_xd_2' );
assert_equals( sum(wd), 1, 'sum_wd_2' );
[X,Y]=meshgrid( dummy_rule(5) );
assert_equals( sortrows(xd'), [X(:),Y(:)], 'xd_2' );

% test 3: dummy in dim 2 with diff stages
[xd,wd]=full_tensor_grid( 2, [3 6], @dummy_rule );
assert_equals( sum(xd,2), [0;0], 'sum_xd_2b' );
assert_equals( sum(wd), 1, 'sum_wd_2b' );
[X,Y]=meshgrid( dummy_rule(3), dummy_rule(6) );
assert_equals( sortrows(xd'), [X(:),Y(:)], 'sum_xd_2b' );

% test 4: dummy in dim 7
[xd,wd]=full_tensor_grid( 7, [4 3 2 2 2 2 2], @dummy_rule );
assert_equals( norm(sum(xd,2)), 0, 'sum_xd_4' );
assert_equals( sum(wd), 1, 'sum_wd_4' );
assert_equals( numel(wd), 384, 'numel_wd_4' );
assert_equals( numel(xd), 7*384, 'numel_xd_4' );



function [x,w]=dummy_rule( p ) 
x=linspace(-1,1,p);
w=linspace(0,1,p);
w=w/sum(w);




