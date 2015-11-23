function test_munit
% TEST_MUNIT Test the munit framework itself.
%   TEST_MUNIT will perform a self test of the munit unit testing
%   framework. Note it is normal that lots of failure messages are printed,
%   as that is what a unit testing framework should print, when it
%   encounters one. You know that the test was successful when the last
%   line printed was something like:
%     OK: MUnit seems to work as it should...
%   
% Example (<a href="matlab:run_example test_munit">run</a>)
%   test_munit;
%
% See also MUNIT_RUN_TESTSUITE, MUNIT_OPTIONS

%   Elmar Zander
%   Copyright 2009, Inst. of Scientific Computing
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
fprintf('Testing: set_debug function...\n');
munit_set_debug;
test_equal( munit_options('get', 'debug'), true, 'sd_default' );
munit_set_debug(true);
test_equal( munit_options('get', 'debug'), true, 'sd_true' );
munit_set_debug(12.2);
test_equal( munit_options('get', 'debug'), true, 'sd_num1' );
munit_set_debug yes
test_equal( munit_options('get', 'debug'), true, 'sd_str1' );
munit_set_debug on
test_equal( munit_options('get', 'debug'), true, 'sd_str2' );
munit_set_debug true
test_equal( munit_options('get', 'debug'), true, 'sd_str3' );
test_equal( munit_set_debug('state'), true, 'sd_state' );

munit_set_debug(false);
test_equal( munit_options('get', 'debug'), false, 'sd_false' );
munit_set_debug(0);
test_equal( munit_options('get', 'debug'), false, 'sd_num2' );
munit_set_debug no
test_equal( munit_options('get', 'debug'), false, 'sd_str4' );
munit_set_debug off
test_equal( munit_options('get', 'debug'), false, 'sd_str5' );
munit_set_debug false
test_equal( munit_options('get', 'debug'), false, 'sd_str6' );
test_equal( munit_set_debug('state'), false, 'sd_state2' );


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
fprintf('Testing: set_function function...\n');
unittest_foo;


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
unittest_assert_equals;
munit_print_stats;
test_stats(munit_stats,53,46,27,1,[],'stats_assert_equals1');
munit_stats('pop');
munit_print_stats;
test_stats(munit_stats,53,0,31,2,[],'stats_assert_equals2');

munit_stats('push','sab');
unittest_assert_bool;
munit_print_stats;
test_stats(munit_stats,61,8,4,0,[],'stats_assert_bool1');
munit_stats('pop');
munit_print_stats;
test_stats(munit_stats,61,0,35,2,[],'stats_assert_bool2');

munit_stats('push','infnan');
unittest_assert_equals_inf_nan;
munit_print_stats;
test_stats(munit_stats,70,9,6,0,[],'stats_assert_bool1');
munit_stats('pop');
munit_print_stats;
test_stats(munit_stats,70,0,41,2,[],'stats_assert_bool2');


munit_stats('push','error');
unittest_assert_error;
munit_print_stats;
test_stats(munit_stats,76,6,3,0,[],'stats_assert_error1');
munit_stats('pop');
munit_print_stats;
test_stats(munit_stats,76,0,44,2,[],'stats_assert_error2');

munit_stats('push','streq');
unittest_assert_equals_struct;
munit_print_stats;
test_stats(munit_stats,81,5,2,0,[],'stats_assert_equals_struct1');
munit_stats('pop');
munit_print_stats;
test_stats(munit_stats,81,0,46,2,[],'stats_assert_equals_struct2');


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

function unittest_assert_equals
munit_set_function('assert_equals');
assert_equals( 1, 'a', 'fail_class_mismatch1' );
assert_equals( {1}, 'a', 'fail_class_mismatch2' );
assert_equals( ones(1,1), ones(2,1), 'fail_size_mismatch1' );
assert_equals( ones(1,3), ones(3,1), 'fail_size_mismatch2' );
assert_equals( ones(2,2), ones(2,2,2), 'fail_size_mismatch3' );
assert_equals( ones(2,2,3), ones(2,2,2), 'fail_size_mismatch4' );

munit_options('set', 'max_assertion_disp', 1 );
assert_equals( 1, 2, 'fail_sca_num_mismatch1' );
assert_equals( ones(2,1), 3*ones(2,1), 'fail_vec_num_mismatch1' );
assert_equals( ones(1,2), 4*ones(1,2), 'fail_vec_num_mismatch2' );
assert_equals( ones(2,2), 5*ones(2,2), 'fail_mat_num_mismatch1' );
assert_equals( ones(2,2,2), 6*ones(2,2,2), 'fail_tens_num_mismatch1' );
assert_equals( 1, 1, 'pass_sca_num' );
assert_equals( ones(2,1), ones(2,1), 'pass_vec_num1' );
assert_equals( ones(1,2), ones(1,2), 'pass_vec_num2' );
assert_equals( ones(2,2), ones(2,2), 'pass_mat_num' );
assert_equals( ones(2,2,2), ones(2,2,2), 'pass_tens_num' );

assert_equals( true, false, 'fail_sca_log_mismatch' );
assert_equals( true(2,1), false(2,1), 'fail_vec_log_mismatch' );
assert_equals( false(1,2), true(1,2), 'fail_vec_log_mismatch2' );
assert_equals( true(2,2), false(2,2), 'fail_mat_log_mismatch1' );
assert_equals( false([2,2,2]), true([2,2,2]), 'fail_tens_log_mismatch1' );

assert_equals( true, true, 'pass_sca_log' );
assert_equals( true(2,1), true(2,1), 'pass_vec_log1' );
assert_equals( false(1,2), false(1,2), 'pass_vec_log2' );

assert_equals( 'abc', 'abd', 'fail_str_mismatch' );
assert_equals( 'abcd', 'abcd', 'pass_str' );

munit_options('set', 'max_assertion_disp', 10 );
x.diff=1;
x.unexp=2;
x.dtype='aaa';
x.dsize=ones(1,3);
y.diff=2;
y.miss=3;
y.dtype=true;
y.dsize=ones(1,2);
assert_equals( x, y, 'fail_struct' );
assert_equals( x, x, 'pass_struct_x' );
assert_equals( y, y, 'pass_struct_y' );
assert_equals( struct(), struct(), 'pass_struct_empty' );

assert_equals( cell(1,1), cell(2,1), 'fail_csize_mismatch1' );
assert_equals( cell(1,3), cell(3,1), 'fail_csize_mismatch2' );
assert_equals( cell(2,2), cell(2,2,2), 'fail_csize_mismatch3' );
assert_equals( cell(2,2,3), cell(2,2,2), 'fail_csize_mismatch4' );
assert_equals( {1,2;3,4}, {1,2;3,5}, 'fail_cell1' );
assert_equals( {1,2;3,4}, {1,2;3,'A'}, 'fail_cell2' );
assert_equals( {1,2;3,'a'}, {1,2;3,'A'}, 'fail_cell3' );
assert_equals( {1,2;3,struct('diff',1)}, {1,2;3,struct('diff',2)}, 'fail_cell3' );

x=cell(3,3,3);
y=x; y{3,2,3}=1;
assert_equals( x, y, 'fail_cell' );


assert_equals( cell(1,1), cell(1,1), 'pass_cell1' );
assert_equals( cell(1,2), cell(1,2), 'pass_cell2' );
assert_equals( cell(2,1), cell(2,1), 'pass_cell3' );
assert_equals( cell(2,2), cell(2,2), 'pass_cell4' );
assert_equals( {1,'aaa',true}, {1,'aaa',true}, 'pass_cell5' );
assert_equals( cell(2,2,2), cell(2,2,2), 'pass_cell6' );

assert_equals( 1, 2, 'fail_fuzzy', 'fuzzy', true );

function unittest_assert_equals_struct
% compare struct arrays
s(1).a = 1;
s(2).a = 2;
t(1).a = 1;
t(2).a = 3;
u(1).a=1;
u(1).b=2;
assert_equals(s, s, 'pass_same');
assert_equals(s(1:0), t(1:0), 'pass_same');
assert_equals(s, t, 'fail_not_same');
assert_equals(s(1), t(1), 'pass_equals');
assert_equals(s(1), u, 'fail_fields');


function unittest_assert_equals_inf_nan
munit_set_function('assert_equals_inf_nan');
assert_equals( [inf, -inf, 1], [inf, -inf, 1], 'pass_inf_inf1' );
assert_equals( [inf, -inf, 1], [inf, -inf, 2], 'fail_inf_inf2' );
assert_equals( inf, 1, 'fail_inf1' );
assert_equals( inf, -inf, 'fail_inf2' );
assert_equals( inf, nan, 'fail_inf3' );
assert_equals( inf, inf, 'fail_inf_inf_nonequalinf', 'equalinf', false );
assert_equals( [nan, 1], [nan, 1], 'pass_nan1' );
assert_equals( nan, nan, 'fail_nan_nonequalnan', 'equalnan', false );
assert_equals( [nan, inf, 1, -inf], [nan, inf, 1, -inf], 'pass_nan1' );


function unittest_assert_bool
munit_set_function('assert_true');
assert_true( true, 'some message (1)', 'pass_bool1' );
assert_true( true, 'some message (2)' );
assert_true( false, 'some message (3)', 'fail_bool1' );
assert_true( false, 'some message (4)' );
assert_false( true, 'some message (1)', 'fail_bool2' );
assert_false( true, 'some message (2)' );
assert_false( false, 'some message (3)', 'pass_bool2' );
assert_false( false, 'some message (4)' );


function unittest_assert_error
munit_set_function('assert_error');
A=rand(3);
B=rand(4);
assert_error( {@times, {A,B}, {1,2}}, 'MATLAB:dimagree', 'pass_corr_error1' )
assert_error( {@times, {A,B}, {1,2}}, 'MATLAB', 'pass_corr_error2' )
assert_error( {@times, {A,B}, {1,2}}, '.*:dimagree', 'pass_corr_error3' )
assert_error( {@times, {A,A}, {1,2}}, 'MATLAB:dimagree', 'fail_no_error' )
assert_error( {@times, {A,B}, {1,2}}, 'foo:bar', 'fail_wrong_error' )
assert_error( {@times, {A,B}, {1,2}}, '^ATLAB', 'fail_wrong_error2' )

function unittest_foo
munit_set_function('wrong_name');
fname=munit_stats( 'get', 'function_name');
if ~strcmp(fname,'wrong_name')
    error('tmu:sf', 'error setting function name ...');
end
munit_set_function;
fname=munit_stats( 'get', 'function_name');
if ~strcmp(fname,'foo')
    error('tmu:sf', 'error detecting function name from unittest name...(%s~=%s)', fname, 'foo');
end
some_sub_function('foo');
unittest_bar;

function unittest_bar
munit_set_function('wrong_name');
munit_set_function;
fname=munit_stats( 'get', 'function_name');
if ~strcmp(fname,'bar')
    error('tmu:sf', 'error detecting function name from unittest name...(%s~=%s)', fname, 'bar');
end
some_sub_function('bar');

function some_sub_function(expected_name)
munit_set_function('wrong_name');
munit_set_function;
fname=munit_stats( 'get', 'function_name');
if ~strcmp(fname, expected_name)
    error('tmu:sf', 'error detecting function name from unittest name...(%s~=%s)', fname, expected_name);
end


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
