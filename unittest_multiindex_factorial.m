function unittest_multiindex_factorial
% UNITTEST_MULTIINDEX_FACTORIAL Test the MULTIINDEX_FACTORIAL function.
%
% Example (<a href="matlab:run_example unittest_multiindex_factorial">run</a>)
%    unittest_multiindex_factorial
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


munit_set_function( 'multiindex_factorial' );
fac=multiindex_factorial( [0,1,2,3,4]' );
assert_equals( fac, [1,1,2,6,24]', 'factorial' );

ind=multiindex(2, 6, 'use_sparse',true);
fac=multiindex_factorial(ind([1,2,3,25,28],:));
assert_equals( fac, [1,1,1,36,720]', 'factorial' );
