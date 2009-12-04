function test_munit(varargin)
% TEST_MUNIT Test the munit framework itself.
%
% Example (<a href="matlab:run_example test_munit">run</a>)
%   test_munit;
%
% See also

%   Elmar Zander
%   Copyright 2009, Inst. of Scientific Comuting
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.



% Since we cannot use munit here itself we have to rely on more basic 
% matlab features to do the checking...

clc;
fprintf('Running MUnit test...\n');

dbstop if error test_munit:equal

%% stats function
fprintf('Testing: stats function...\n');

munit_stats('init');
test_stats(munit_stats,0,0,0,0,{},'init');
munit_stats('add', 'f1', false );
test_stats(munit_stats,1,1,1,0,{'f1'},'add1');
munit_stats('add', 'f2', false, true );
test_stats(munit_stats,2,2,1,1,{'f1','f2'},'add2');
munit_stats('add', 'f3', true, true );
test_stats(munit_stats,3,3,1,1,{'f1','f2','f3'},'add3');
munit_stats('push');
test_stats(munit_stats,3,0,0,0,{},'push');
munit_stats('pop');
test_stats(munit_stats,3,3,1,1,{'f1','f2','f3'},'pop');
munit_stats('push');
test_stats(munit_stats,3,0,0,0,{},'push');
munit_stats('add', 'f4', false );
test_stats(munit_stats,4,1,1,0,{'f4'},'add4');
munit_stats('add', 'f5', false, true );
test_stats(munit_stats,5,2,1,1,{'f4','f5'},'add5');
munit_stats('pop');
test_stats(munit_stats,5,3,2,2,{'f1','f2','f3','f4','f5'},'pop');

munit_stats('init');
test_stats(munit_stats,0,0,0,0,{},'init2')

munit_stats('init');
s=munit_stats;
test_equal( s.module_name, '<unknown>', 'unknown' );
munit_stats('push','xxx');
s=munit_stats;
test_equal( s.module_name, 'xxx', 'unknown' );
munit_stats('push');
s=munit_stats;
test_equal( s.module_name, '<unknown>', 'unknown' );
munit_stats('init','xxx');
s=munit_stats;
test_equal( s.module_name, 'xxx', 'unknown' );

munit_stats('init');
test_stats(munit_stats,0,0,0,0,{},'init3')
munit_stats('set', 'current_assertion', 12 );
test_stats(munit_stats,0,12,0,0,{},'set_ca')
test_equal( munit_stats('get', 'current_assertion'), 12, 'notempty' );
munit_stats('set', 'assertions_failed', 123 );
test_equal( munit_stats('get', 'assertions_failed'), 123, 'notempty' );
test_stats(munit_stats,0,12,123,0,{},'set_ca')



%% 
fprintf('Testing: options function...\n');

s=munit_options;
test_equal( isempty(s), false, 'notempty' );
test_equal( class(s), 'struct', 'struct' );
test_equal( isfield(s,'abstol'), true, 'hasabstol' );
oldabstol=s.abstol;
munit_options('set','newfield',3);
munit_options('set','abstol',10);
s=munit_options('get');
test_equal( s.newfield, 3, 'setget' );
test_equal( munit_options('get', 'newfield'), 3, 'setget' );
test_equal( s.abstol, 10, 'setget' );
munit_options('reset');
s=munit_options();
test_equal( s.abstol, oldabstol, 'reset' );
s=munit_options();
test_equal( s.abstol, oldabstol, 'reset2' );
munit_set_debug();
s=munit_options();
test_equal( s.debug, true, 'debugon' );
munit_set_debug('off');
s=munit_options();
test_equal( s.debug, false, 'debugoff' );

%% 
fprintf('Testing: assertion function...\n');
fprintf('Check that the following looks reasonably yourself...\n');
fprintf('=====================================================\n');
munit_stats('init','munit');

munit_stats('push','spa');
unittest_process_assert;
munit_print_stats;
test_stats(munit_stats,7,7,4,1,[],'stats_proc_assert1');
munit_stats('pop');
munit_print_stats;
test_stats(munit_stats,7,0,4,1,[],'stats_proc_assert2');

munit_stats('push','saeq');
unittest_assert;
munit_print_stats;
%test_stats(munit_stats,13,6,6,0,[],'stats_assert_equals1');
munit_stats('pop');
munit_print_stats;
%test_stats(munit_stats,13,0,10,1,[],'stats_assert_equals2');
fprintf('=====================================================\n');


%% 
fprintf('OK: MUnit seems to work as it should...\n');


function unittest_process_assert
munit_set_function('munit_process_assert_results');
munit_process_assert_results( {}, 'pass_1' );
munit_process_assert_results( {}, '' );
munit_process_assert_results( {{'ass failed'}}, 'fail_3' );
munit_process_assert_results( {{'fuz ass failed'}}, 'fail_poss_4', 'fuzzy', true );
munit_process_assert_results( {{'foo'}, {'bar'}}, 'fail_5' );
munit_process_assert_results( {{'foo', 'fail_6.f1'}, {'bar'},{'baz', 'fail_6[3]'}}, 'fail_6' );
munit_options('set', 'max_assertion_disp', 2 );
munit_process_assert_results( {{'1', 'fail_7[1]_is_ok'}, {'2', 'fail_7[2]_is_ok'}, {'3', 'fail_7[3]_but_dont_show'}}, 'fail_7' );
munit_options('set', 'max_assertion_disp', 10 );

function unittest_assert
munit_set_function('assert_equals');
assert_equals( 1, 'a', 'fail_class_mismatch1' );
assert_equals( {1}, 'a', 'fail_class_mismatch2' );
assert_equals( ones(1,1), ones(2,1), 'fail_size_mismatch1' );
assert_equals( ones(1,3), ones(3,1), 'fail_size_mismatch2' );
assert_equals( ones(2,2), ones(2,2,2), 'fail_size_mismatch3' );
assert_equals( ones(2,2), ones(2,2,2), 'fail_size_mismatch4' );

assert_equals( 1, 2, 'fail_sca_num_mismatch1' );

%assert_equals( 1, 1, 's_num_true' );
%assert_equals( 1, 2, 's_num_false' );

%% 
function test_stats(s,ta,ca,af,afp,tf,id)
test_equal( s.total_assertions, ta, [id '-ta'] );
test_equal( s.current_assertion, ca, [id '-ca'] );
test_equal( s.assertions_failed, af, [id '-af'] );
test_equal( s.assertions_failed_poss, afp, [id '-afp'] );
if iscell(tf)
    test_equal( s.tested_functions, tf, [id '-tf'] );
end


function test_equal( a, b, msg )
if ~strcmp(class(a),class(b))
    error( 'test_munit:equal', 'values have different types' );
end
if ischar(a)
    if ~strcmp( a, b )
        error( 'test_munit:equal', 'values don'' match: %s', msg );
    end
elseif isnumeric(a)
    if ~all( a(:)==b(:) )
        error( 'test_munit:equal', 'values don'' match: %s', msg );
    end
elseif islogical(a)
    if ~all( a(:)==b(:) )
        error( 'test_munit:equal', 'values don'' match: %s', msg );
    end
elseif iscell(a)
    if numel(a)~=numel(b)
        error( 'test_munit:equal', 'size not equal: %s', msg );
    end
    for i=1:numel(a)
        test_equal(a{i}, b{i}, msg );
    end
else
    error( 'test_munit:equal', 'unknown type to compare' );
end
