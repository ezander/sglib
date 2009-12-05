function unittest_multiindex
% UNITTEST_MULTIINDEX Test the MULTIINDEX function.
%
% Example (<a href="matlab:run_example unittest_multiindex">run</a>)
%    unittest_multiindex
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


munit_set_function( 'multiindex' );

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
assert_equals( numel(ind), 0, 'mzero_size' )
