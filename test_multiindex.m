function test_multiindex
% TEST_MULTIINDEX Test multi-index related functions.
%
% Example (<a href="matlab:run_example test_multiindex">run</a>) 
%    test_multiindex
%
% See also TESTSUITE

%   Elmar Zander
%   Copyright 2007, Institute of Scientific Computing, TU Braunschweig.
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


% Test for MULTIINDEX
assert_set_function( 'multiindex' );

ind=multiindex(2,6);
assert_false( issparse(ind), 'multiindex should be full matrix', 'not_sparse' )
assert_equals( size(ind), [28, 2], 'size' )
assert_equals( ind(1,:), [0, 0], 'first' )
assert_equals( ind(end,:), [0, 6], 'last' )
assert_equals( unique(ind(:,1)), (0:6)', 'unique' )
assert_equals( unique(ind(:,2)), (0:6)', 'unique' )
assert_equals( size(unique(ind,'rows'),1), 28, 'unique' )

ind=multiindex(2,6,[],'use_sparse',true);
assert_true( issparse(ind), 'multiindex should be sparse matrix', 'not_sparse' )
assert_equals( size(ind), [28, 2], 'sp_size' )
assert_equals( ind(1,:), [0, 0], 'sp_first' )
assert_equals( ind(end,:), [0, 6], 'sp_last' )
assert_equals( unique(ind(:,1)), (0:6)', 'sp_unique' )
assert_equals( unique(ind(:,2)), (0:6)', 'sp_unique' )
assert_equals( size(unique(ind,'rows'),1), 28, 'sp_unique' )

ind=multiindex(200,1,[],'use_sparse',true);
assert_equals( size(ind), [201, 200], 'large_nrv' )

ind=multiindex( 0, 7 );
assert_equals( prod(size(ind)), 0, 'mzero_size' )


% Test for MULTIINDEX_FACTORIAL
assert_set_function( 'multiindex_factorial' );
fac=multiindex_factorial( [0,1,2,3,4]' );
assert_equals( fac, [1,1,2,6,24]', 'factorial' );

ind=multiindex(2,6,[],'use_sparse',true);
fac=multiindex_factorial(ind([1,2,3,25,28],:));
assert_equals( fac, [1,1,1,36,720]', 'factorial' );


% Test for MULTIINDEX_ORDER
assert_set_function( 'multiindex_order' );
fac=multiindex_order(ind([1,2,3,25,28],:));
assert_equals( fac, [0,1,1,6,6]', 'order' );


% Test for MULTIINDEX_COMBINE
assert_set_function( 'multiindex_combine' );

I_f0=multiindex(2,6,[],'use_sparse', false);
I_k0=multiindex(4,5,[],'use_sparse', false);
I_g0=multiindex(6,3,[],'use_sparse', false);
[I_f,I_k,I_g,I_u]=multiindex_combine({I_f0,I_k0,I_g0},-1);
assert_equals( size(I_f), [28,12], 'size1' );
assert_equals( size(I_k), [126,12], 'size2' );
assert_equals( size(I_g), [84,12], 'size3' );
assert_equals( size(I_u), [18564,12], 'size4' );
assert_equals( I_f(:,1:2), I_f0, 'contain1' );
assert_equals( I_k(:,3:6), I_k0, 'contain2' );
assert_equals( I_g(:,7:12), I_g0, 'contain3' );

I_f0=multiindex(2,6,[],'use_sparse', true);
I_k0=multiindex(4,5,[],'use_sparse', true);
I_g0=multiindex(6,3,[],'use_sparse', true);
[I_f,I_k,I_g,I_u]=multiindex_combine({I_f0,I_k0,I_g0},-1);
assert_equals( size(I_f), [28,12], 'sp_size1' );
assert_equals( size(I_k), [126,12], 'sp_size2' );
assert_equals( size(I_g), [84,12], 'sp_size3' );
assert_equals( size(I_u), [18564,12], 'sp_size4' );
assert_equals( I_f(:,1:2), I_f0, 'sp_contain1' );
assert_equals( I_k(:,3:6), I_k0, 'sp_contain2' );
assert_equals( I_g(:,7:12), I_g0, 'sp_contain3' );


% Test for MULTIINDEX_FIND
assert_set_function( 'multiindex_find' );

I=multiindex(5,3);

alpha=[0 0 0 0 0]; 
ind=multiindex_find( I, alpha );
assert_equals( find(ind), 1, 'zero_ind');
assert_equals( I(ind,:), alpha, 'zero_eq' );

alpha=[0 1 0 0 2]; 
ind=multiindex_find( I, alpha );
assert_equals( I(ind,:), alpha, 'eq' );

