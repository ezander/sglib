function unittest_sobol_sequence(varargin)
% UNITTEST_SOBOL_SEQUENCE Test the SOBOL_SEQUENCE function.
%
% Example (<a href="matlab:run_example unittest_sobol_sequence">run</a>)
%   unittest_sobol_sequence
%
% See also SOBOL_SEQUENCE, MUNIT_RUN_TESTSUITE

%   Elmar Zander
%   Copyright 2016, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'sobol_sequence' );


N=1043;
D=8;
filename='new-joe-kuo-6.21201';

% N=1043;
% D=8;
% points = sobol_sequence(N, D, filename)

% Test 10 3
points = sobol_sequence(10, 3, 'filename', filename);
ex_sequence=[
    0 0 0
    0.5 0.5 0.5
    0.75 0.25 0.25
    0.25 0.75 0.75
    0.375 0.375 0.625
    0.875 0.875 0.125
    0.625 0.125 0.875
    0.125 0.625 0.375
    0.1875 0.3125 0.9375
    0.6875 0.8125 0.4375
    ];
assert_equals(points, ex_sequence, 'kuo_10_3');


% Test 10 3
points = sobol_sequence(3, 10, 'filename', filename);
ex_sequence=[
    0 0 0 0 0 0 0 0 0 0
    0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5
    0.75 0.25 0.25 0.25 0.75 0.75 0.25 0.75 0.75 0.75
    ];
assert_equals(points, ex_sequence, 'kuo_3_10');


% Test 123 27
points = sobol_sequence(123, 27, 'filename', filename);
ex_sequence=[
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
    0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5
    0.75 0.25 0.25 0.25 0.75 0.75 0.25 0.75 0.75 0.75 0.75 0.75 0.25 0.25 0.75 0.25 0.75 0.25 0.75 0.25 0.25 0.75 0.25 0.25 0.25 0.75 0.25
    0.25 0.75 0.75 0.75 0.25 0.25 0.75 0.25 0.25 0.25 0.25 0.25 0.75 0.75 0.25 0.75 0.25 0.75 0.25 0.75 0.75 0.25 0.75 0.75 0.75 0.25 0.75
    0.375 0.375 0.625 0.875 0.375 0.125 0.375 0.875 0.875 0.625 0.875 0.375 0.375 0.625 0.375 0.875 0.375 0.875 0.875 0.125 0.125 0.125 0.375 0.875 0.875 0.875 0.375
    % Lines 6 to 118 skipped
    0.6953125 0.4765625 0.9921875 0.3203125 0.4140625 0.5234375 0.8046875 0.3828125 0.1015625 0.3515625 0.6796875 0.0234375 0.5703125 0.1953125 0.7890625 0.2109375 0.6484375 0.3984375 0.8671875 0.1171875 0.2265625 0.3046875 0.8515625 0.6484375 0.8046875 0.9140625 0.6015625
    0.1953125 0.9765625 0.4921875 0.8203125 0.9140625 0.0234375 0.3046875 0.8828125 0.6015625 0.8515625 0.1796875 0.5234375 0.0703125 0.6953125 0.2890625 0.7109375 0.1484375 0.8984375 0.3671875 0.6171875 0.7265625 0.8046875 0.3515625 0.1484375 0.3046875 0.4140625 0.1015625
    0.1328125 0.0390625 0.9296875 0.5078125 0.3515625 0.2109375 0.6171875 0.6953125 0.7890625 0.4140625 0.2421875 0.7109375 0.2578125 0.1328125 0.7265625 0.3984375 0.8359375 0.0859375 0.0546875 0.1796875 0.4140625 0.1171875 0.7890625 0.9609375 0.1171875 0.8515625 0.1640625
    0.6328125 0.5390625 0.4296875 0.0078125 0.8515625 0.7109375 0.1171875 0.1953125 0.2890625 0.9140625 0.7421875 0.2109375 0.7578125 0.6328125 0.2265625 0.8984375 0.3359375 0.5859375 0.5546875 0.6796875 0.9140625 0.6171875 0.2890625 0.4609375 0.6171875 0.3515625 0.6640625
    0.8828125 0.2890625 0.6796875 0.7578125 0.6015625 0.9609375 0.8671875 0.4453125 0.0390625 0.6640625 0.9921875 0.4609375 0.0078125 0.3828125 0.4765625 0.1484375 0.0859375 0.3359375 0.8046875 0.4296875 0.1640625 0.8671875 0.5390625 0.7109375 0.3671875 0.1015625 0.4140625
    ];
assert_equals(points([1:5, end-4:end],:), ex_sequence, 'kuo_123_27');


% Test 1000 1
points = sobol_sequence(1000, 1, 'filename', filename);
ex_sequence=[
    0
    0.5
    0.75
    0.25
    0.375
    % some lines missing here
    0.2822265625
    0.4072265625
    0.9072265625
    0.6572265625
    0.1572265625
    ];
assert_equals(points([1:5, end-4:end]), ex_sequence, 'kuo_1000_1');
