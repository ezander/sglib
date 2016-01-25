function unittest_param_study
% UNITTEST_PARAM_STUDY Test the PARAM_STUDY function.
%
% Example (<a href="matlab:run_example unittest_param_study">run</a>)
%   unittest_param_study
%
% See also PARAM_STUDY, MUNIT_RUN_TESTSUITE 

%   Elmar Zander
%   Copyright 2010, Inst. of Scientific Computing
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.
munit_set_function( 'param_study' );

if isversion('8.3')
    % TODO: with the replacement of the depfun function with
    % requiredToolsAndProducts this functionality has become pretty slow
    % and partly unstable. Fix when there's enough time.
    return
end


%clear_funcall_cache( 'pattern', mfilename, 'verbosity', 1 );
%ps_options={'cache', false, 'cache_file', mfilename, 'verbosity', 1, 'cache_partial', false };
%ps_options={'cache', true, 'verbosity', 1, 'cache_partial', true };
ps_options={'cache', false, 'verbosity', 0, 'cache_partial', false };

clear var_params def_params
var_params.a=[1,2,3];
def_params.b=4;
def_params.x=4.5;
var_params.x={1.2, 3.4};
def_params.y=pi;
def_params.str1='x1';
var_params.str2={'y1', 'y2', 'y3', 'y4'};

ret_names={'ab', 'z', 'res', 'info', {'w', 'ab*z(3)'}};

s=param_study( 'param_study_unittest_script', var_params, def_params, ret_names, ps_options{:} );

assert_equals( sort(fieldnames(s)), {'a', 'ab', 'info', 'res', 'str2', 'w', 'x', 'z'}', 'fields' );
assert_equals( size(s.a), [3,2,4], 'size1' );
assert_equals( size(s.str2), [3,2,4], 'size2' );
assert_equals( s.a{2,1,4}, var_params.a(2), 'a(2)' );
assert_equals( s.x{2,1,4}, var_params.x{1}, 'x(1)' ); % not the def value
assert_equals( s.z{3,2,4}(1), var_params.x{2}^var_params.a(3), 'z(3,2,4)(1)' ); % not the def value
assert_equals( s.info{2,1,4}.st, 'y4', 'str2_y4' );


clear var_params def_params
var_params.a=[1,2,3];
def_params.b=4;
def_params.x=4.5;
def_params.x=1.2;
def_params.y=pi;
def_params.str1='x1';
def_params.str2='y1';
s=param_study( 'param_study_unittest_script', var_params, def_params, ret_names, ps_options{:} );
assert_equals( size(s.a), [3,1], 'size1' );
