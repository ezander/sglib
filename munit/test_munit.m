function test_munit
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
test_stats(munit_stats,0,0,0,0,{},'init')
munit_stats('add', 'f1', false );
test_stats(munit_stats,1,1,1,0,{'f1'},'add1')
munit_stats('add', 'f2', false, true );
test_stats(munit_stats,2,2,1,1,{'f1','f2'},'add2')
munit_stats('add', 'f3', true, true );
test_stats(munit_stats,3,3,1,1,{'f1','f2','f3'},'add3')
munit_stats('push');
test_stats(munit_stats,3,0,0,0,{},'push')
munit_stats('pop');
test_stats(munit_stats,3,3,1,1,{'f1','f2','f3'},'pop')
munit_stats('push');
test_stats(munit_stats,3,0,0,0,{},'push')
munit_stats('add', 'f4', false );
test_stats(munit_stats,4,1,1,0,{'f4'},'add4')
munit_stats('add', 'f5', false, true );
test_stats(munit_stats,5,2,1,1,{'f4','f5'},'add5')
munit_stats('pop');
test_stats(munit_stats,5,3,2,2,{'f1','f2','f3','f4','f5'},'pop')

munit_stats('init');
test_stats(munit_stats,0,0,0,0,{},'init2')

munit_stats('init');
s=munit_stats;
test_equal( s.module_name, '<unknown>', 'unknown' )
munit_stats('push','xxx');
s=munit_stats;
test_equal( s.module_name, 'xxx', 'unknown' )
munit_stats('push');
s=munit_stats;
test_equal( s.module_name, '<unknown>', 'unknown' )
munit_stats('init','xxx');
s=munit_stats;
test_equal( s.module_name, 'xxx', 'unknown' )

%% 
fprintf('Testing: options function...\n');

s=munit_options;
test_equal( isempty(s), 0, 'notempty' )
test_equal( class(s), 'struct', 'notempty' )



%% 
fprintf('OK: MUnit seems to work as it should...\n');

%% 
function test_stats(s,ta,ca,af,afp,tf,id)
test_equal( s.total_assertions, ta, [id '-ta'] );
test_equal( s.current_assertion, ca, [id '-ca'] );
test_equal( s.assertions_failed, af, [id '-af'] );
test_equal( s.assertions_failed_poss, afp, [id '-afp'] );
test_equal( s.tested_functions, tf, [id '-tf'] );


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
