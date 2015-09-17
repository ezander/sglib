function unittest_gendist_get_args
% UNITTEST_GENDIST_GET_ARGS Test the GENDIST_GET_ARGS function.
%
% Example (<a href="matlab:run_example unittest_gendist_get_args">run</a>)
%   unittest_gendist_get_args
%
% See also GENDIST_GET_ARGS, MUNIT_RUN_TESTSUITE 

%   Elmar Zander
%   Copyright 2014, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'gendist_get_args' );

expect1 = {'beta', {1,2}, 3, 4, beta_moments(1,2)};
expect2 = {'beta', {1,2}, 3, 1, beta_moments(1,2)};
expect3 = {'beta', {1,2}, 0, 4, beta_moments(1,2)};
expect4 = {'beta', {1,2}, 0, 1, beta_moments(1,2)};
expect5 = {'beta', {1,2}, 3, 4, 8};

% test with old calling conventions
warn_state = warning('off', 'sglib:statistics:gendist');
assert_equals(gendist_get_args('beta', {{1,2}, 3, 4}), expect1, 'cvold1');
assert_equals(gendist_get_args('beta', {{1,2}, 3, []}), expect2, 'cvold2');
assert_equals(gendist_get_args('beta', {{1,2}, [], 4}), expect3, 'cvold3');
assert_equals(gendist_get_args('beta', {{1,2}, [], []}), expect4, 'cvold4');
assert_equals(gendist_get_args('beta', {{1,2}, 3}), expect2, 'cvold5');
assert_equals(gendist_get_args('beta', {{1,2}, []}), expect4, 'cvold6');
assert_equals(gendist_get_args('beta', {{1,2}}), expect4, 'cvold7');

assert_equals(gendist_get_args('normal', {}), {'normal', {}, 0, 1, normal_moments()}, 'cvold8');
assert_equals(gendist_get_args('lognormal', {}), {'lognormal', {}, 0, 1, lognormal_moments()}, 'cvold9');
warning(warn_state);

% test with new calling conventions
assert_equals(gendist_get_args({'beta', {1,2}, 3, 4}, {}), expect1, 'cvnew1');
assert_equals(gendist_get_args({'beta', {1,2}, 3, 4, 8}, {}), expect5, 'cvnew2');

% errors
assert_error(funcreate(@gendist_get_args, {'beta', {1,2}, 3, 4, 8}, {2}), 'sglib', 'einval_arg1');
assert_error(funcreate(@gendist_get_args, 15, {}), 'sglib', 'einval_arg2');
