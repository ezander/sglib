function unittest_multiindex
% UNITTEST_MULTIINDEX Test the MULTIINDEX function.
%
% Example (<a href="matlab:run_example unittest_multiindex">run</a>)
%    unittest_multiindex
%
% See also TESTSUITE

%   Elmar Zander
%   Copyright 2007, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


munit_set_function( 'multiindex' );

ind=multiindex(2,6);
assert_false( issparse(ind), 'multiindex should be full matrix', 'not_sparse' )
assert_equals( size(ind), [28, 2], 'size' )
assert_equals( ind(1,:), [0, 0], 'first' )
assert_equals( ind(end,:), [0, 6], 'last' )
assert_equals( unique(ind(:,1)), (0:6)', 'unique' )
assert_equals( unique(ind(:,2)), (0:6)', 'unique' )
assert_equals( size(unique(ind,'rows'),1), 28, 'unique' )

ind=multiindex(2,6,'use_sparse',true);
assert_true( issparse(ind), 'multiindex should be sparse matrix', 'not_sparse' )
assert_equals( size(ind), [28, 2], 'sp_size' )
assert_equals( ind(1,:), [0, 0], 'sp_first' )
assert_equals( ind(end,:), [0, 6], 'sp_last' )
assert_equals( unique(ind(:,1)), (0:6)', 'sp_unique' )
assert_equals( unique(ind(:,2)), (0:6)', 'sp_unique' )
assert_equals( size(unique(ind,'rows'),1), 28, 'sp_unique' )

ind=multiindex(200,1,'use_sparse',true);
assert_equals( size(ind), [201, 200], 'large_nrv' )

ind=multiindex( 0, 7 );
assert_equals( numel(ind), 0, 'mzero_size' )

% lexicographical 
ind=multiindex( 3, 5, 'ordering', 'lex' );
assert_true( all(diff(ind * [1; 8; 64])>0), 'ordering not lexico. increasing', 'lex_increasing' )

% create using other parameter
ind2=multiindex( 3, 5, 'lex_ordering', true );
assert_equals(ind2, ind, 'lex_param');

% test uqtoolkit ordering
% (the functional tested may look a bit strange here: the first one
% computes the order per index, takes the difference and makes sure it is
% increasing, the second one makes sure the ordering is increasing by
% degree and for each degree lexicographically decreasing).
ind=multiindex( 3, 5, 'ordering', 'uqtk' );
assert_true( all(diff(sum(ind, 2))>=0), ...
    'degree not increasing', 'uqtk_increasing' )
assert_true( all(diff(ind * [36;6;1] + 217*(5-sum(ind,2)))<0), 'functional not decreasing', 'uqtk_func_dec')

% degree ordering test
ind=multiindex( 3, 5, 'ordering', 'degree' );
assert_true( all(diff(sum(ind, 2))>=0), ...
    'degree not increasing', 'deg_increasing' )
assert_true( all(diff(ind * [1;6;36] + 217*sum(ind,2))>0), 'functional not increasing', 'deg_func_inc')

% tensor product test
ind=multiindex( 3, 5, 'full', true, 'lex_ordering', true );
assert_equals(ind * [1;6;36], (0:215)', 'full_tensor_lex');

ind=multiindex( 3, 5, 'full', true, 'lex_ordering', false );
assert_equals(sort(ind * [1;6;36]), (0:215)', 'full_tensor');
assert_true(all(diff(sum(ind,2))>=0), 'degree not increasing', 'full_tensor_inc_deg');


%% Test of special cases (p==0, p==1)
ind=multiindex( 8, 0, 'full', false, 'lex_ordering', true );
assert_equals(ind, zeros(1,8), 'p0_full');
assert_matrix(ind, 'full', 'p0_full');
ind=multiindex( 8, 0, 'full', false, 'use_sparse', true );
assert_equals(ind, zeros(1,8), 'p0_sparse');
assert_matrix(ind, 'sparse', 'p0_sparse');

ind=multiindex( 8, 1, 'full', false, 'lex_ordering', true );
assert_equals(ind, [zeros(1,8); eye(8)], 'p1_full');
assert_matrix(ind, 'full', 'p1_full');
ind=multiindex( 8, 1, 'full', false, 'use_sparse', true );
assert_equals(ind, [zeros(1,8); eye(8)], 'p1_sparse');
assert_matrix(ind, 'sparse', 'p1_sparse');


