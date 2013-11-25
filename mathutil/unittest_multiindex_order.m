function unittest_multiindex_order
% UNITTEST_MULTIINDEX_ORDER Test the MULTIINDEX_ORDER function.
%
% Example (<a href="matlab:run_example unittest_multiindex_order">run</a>)
%    unittest_multiindex_order
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

% Test for MULTIINDEX_ORDER
munit_set_function( 'multiindex_order' );
ind=multiindex(2, 6, 'use_sparse',true);
ord=multiindex_order(ind([1,2,3,25,28],:));
assert_equals( ord, [0,1,1,6,6]', 'order' );
