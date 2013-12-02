function unittest_multiindex_combine
% UNITTEST_MULTIINDEX_COMBINE Test the MULTIINDEX_COMBINE function.
%
% Example (<a href="matlab:run_example unittest_multiindex_combine">run</a>)
%    unittest_multiindex_combine
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


munit_set_function( 'multiindex_combine' );

I_f0=multiindex(2, 6, 'use_sparse', false);
I_k0=multiindex(4, 5, 'use_sparse', false);
I_g0=multiindex(6, 3, 'use_sparse', false);
[I_f,I_k,I_g,I_u]=multiindex_combine({I_f0,I_k0,I_g0},-1);
assert_equals( size(I_f), [28,12], 'size1' );
assert_equals( size(I_k), [126,12], 'size2' );
assert_equals( size(I_g), [84,12], 'size3' );
assert_equals( size(I_u), [18564,12], 'size4' );
assert_equals( I_f(:,1:2), I_f0, 'contain1' );
assert_equals( I_k(:,3:6), I_k0, 'contain2' );
assert_equals( I_g(:,7:12), I_g0, 'contain3' );

I_f0=multiindex(2, 6, 'use_sparse', true);
I_k0=multiindex(4, 5, 'use_sparse', true);
I_g0=multiindex(6, 3, 'use_sparse', true);
[I_f,I_k,I_g,I_u]=multiindex_combine({I_f0,I_k0,I_g0},-1);
assert_equals( size(I_f), [28,12], 'sp_size1' );
assert_equals( size(I_k), [126,12], 'sp_size2' );
assert_equals( size(I_g), [84,12], 'sp_size3' );
assert_equals( size(I_u), [18564,12], 'sp_size4' );
assert_equals( I_f(:,1:2), I_f0, 'sp_contain1' );
assert_equals( I_k(:,3:6), I_k0, 'sp_contain2' );
assert_equals( I_g(:,7:12), I_g0, 'sp_contain3' );

