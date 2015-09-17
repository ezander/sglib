function unittest_hammersley_set
% UNITTEST_HAMMERSLEY_SET Test the HAMMERSLEY_SET function.
%
% Example (<a href="matlab:run_example unittest_hammersley_set">run</a>)
%   unittest_hammersley_set
%
% See also HAMMERSLEY_SET, MUNIT_RUN_TESTSUITE 

%   Elmar Zander
%   Copyright 2013, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function('hammersley_set');

l = (1:5)/5;

% test for dim 1
assert_equals(hammersley_set(5, 1), l');

% test for dim 2
assert_equals(hammersley_set(5, 2), [[1/2, 1/4, 3/4, 1/8, 5/8]; l]');

% test for dim 3
assert_equals(hammersley_set(5, 3), [[1/2, 1/4, 3/4, 1/8, 5/8];
    [1/3, 2/3, 1/9, 4/9, 7/9]; l]');
