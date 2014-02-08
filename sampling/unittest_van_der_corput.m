function unittest_van_der_corput
% UNITTEST_VAN_DER_CORPUT Test the VAN_DER_CORPUT function.
%
% Example (<a href="matlab:run_example unittest_van_der_corput">run</a>)
%   unittest_van_der_corput
%
% See also VAN_DER_CORPUT, MUNIT_RUN_TESTSUITE 

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

munit_set_function('van_der_corput');

% test for base 2
assert_equals(van_der_corput(1:9, 2), [1/2, 1/4, 3/4, 1/8, 5/8, 3/8, ...
    7/8, 1/16, 9/16], 'p2');

% test for diff start value
assert_equals(van_der_corput(7:9, 2), [7/8, 1/16, 9/16], 'p2_79');

% test for diff shapes (in=out)
assert_equals(van_der_corput(1:9, 2)', [1/2, 1/4, 3/4, 1/8, 5/8, 3/8, ...
    7/8, 1/16, 9/16]', 'p2_shape');
assert_equals(van_der_corput(ones(3), 2), ones(3)/2, 'p2_shape2');

% test for base 3
assert_equals(van_der_corput(1:9, 3), [1/3, 2/3, 1/9, 4/9, 7/9, 2/9, ...
    5/9, 8/9, 1/27], 'p3');

% test for base 10
assert_equals(van_der_corput(1:23, 10), [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, ...
    0.7, 0.8, 0.9, 0.01, 0.11, 0.21, 0.31, 0.41, 0.51, 0.61, 0.71, ...
    0.81, 0.91, 0.02, 0.12, 0.22, 0.32], 'p10')

% test scramble
scramble_arr = [0, 2, 1];
assert_equals(van_der_corput(1:9, 3, 'scramble_func', scramble_arr), ...
    [2/3, 1/3, 2/9, 8/9, 5/9, 1/9, 7/9, 4/9, 2/27], 'p3_scr_arr');

assert_equals(van_der_corput(1:9, 3, 'scramble_func', @scramble_rev3), ...
    [2/3, 1/3, 2/9, 8/9, 5/9, 1/9, 7/9, 4/9, 2/27], 'p3_scr_func');

% test scramble shape
scramble_arr = [0, 2, 1];
assert_equals(van_der_corput(ones(4,3), 3, 'scramble_func', scramble_arr), ...
    2/3*ones(4,3), 'p3_scr_43');
assert_equals(van_der_corput(ones(4,3), 3, 'scramble_func', scramble_arr'), ...
    2/3*ones(4,3), 'p3_scr_t43');
assert_equals(van_der_corput(ones(1,3), 3, 'scramble_func', scramble_arr), ...
    2/3*ones(1,3), 'p3_scr_13');
assert_equals(van_der_corput(ones(1,3), 3, 'scramble_func', scramble_arr'), ...
    2/3*ones(1,3), 'p3_scr_t13');
assert_equals(van_der_corput(ones(4,1), 3, 'scramble_func', scramble_arr), ...
    2/3*ones(4,1), 'p3_scr_41');
assert_equals(van_der_corput(ones(4,1), 3, 'scramble_func', scramble_arr'), ...
    2/3*ones(4,1), 'p3_scr_t41');


function d = scramble_rev3(d, p, j)
scramble_arr = [0, 2, 1];
d = scramble_arr(d+1);
