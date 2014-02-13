function unittest_halton_sequence
% UNITTEST_HALTON_SEQUENCE Test the HALTON_SEQUENCE function.
%
% Example (<a href="matlab:run_example unittest_halton_sequence">run</a>)
%   unittest_halton_sequence
%
% See also HALTON_SEQUENCE, MUNIT_RUN_TESTSUITE 

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

munit_set_function('halton_sequence');

% test for dim 1
assert_equals(halton_sequence(5, 1), [1/2, 1/4, 3/4, 1/8, 5/8]', 'dim1');

% test for dim 2
assert_equals(halton_sequence(5, 2), [[1/2, 1/4, 3/4, 1/8, 5/8];
    [1/3, 2/3, 1/9, 4/9, 7/9]]', 'dim2');

% test for dim 2, start = 2
assert_equals(halton_sequence(4, 2, 'n0', 2), [[1/4, 3/4, 1/8, 5/8];
    [2/3, 1/9, 4/9, 7/9]]', 'n0_2');

% test for dim 3, braaten-weller scrambling
assert_equals(halton_sequence(5, 3, 'scramble', 'bw'), [[1/2, 1/4, 3/4, 1/8, 5/8];
    [2/3, 1/3, 2/9, 8/9, 5/9]; [2/5, 4/5, 1/5, 3/5, 2/25]]', 'scr_bw');

% test for dim 3, reverse scrambling
assert_equals(halton_sequence(5, 3, 'scramble', 'rev'), [[1/2, 1/4, 3/4, 1/8, 5/8];
    [2/3, 1/3, 2/9, 8/9, 5/9]; [4/5, 3/5, 2/5, 1/5, 4/25]]', 'scr_rev');

% test for extreme cases like zero N or D 
assert_equals(halton_sequence(0, 1), zeros(0,1), 'n0_dim1');
assert_equals(halton_sequence(0, 4), zeros(0,4), 'n0_dim4');
assert_equals(halton_sequence(0, 0), zeros(0,0), 'n0_dim0');
assert_equals(halton_sequence(5, 0), zeros(5,0), 'n5_dim0');
