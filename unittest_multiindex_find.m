function unittest_multiindex_find
% UNITTEST_MULTIINDEX_FIND Test the MULTIINDEX_FIND function.
%
% Example (<a href="matlab:run_example unittest_multiindex_find">run</a>)
%    unittest_multiindex_find
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


assert_set_function( 'multiindex_find' );

I=multiindex(5,3);

alpha=[0 0 0 0 0];
ind=multiindex_find( I, alpha );
assert_equals( find(ind), 1, 'zero_ind');
assert_equals( I(ind,:), alpha, 'zero_eq' );

alpha=[0 1 0 0 2];
ind=multiindex_find( I, alpha );
assert_equals( I(ind,:), alpha, 'eq' );
