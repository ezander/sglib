function unittest_cached_funcall
% UNITTEST_CACHED_FUNCALL Test the CACHED_FUNCALL function.
%
% Example (<a href="matlab:run_example unittest_cached_funcall">run</a>)
%    unittest_cached_funcall
%
% See also TESTSUITE, CACHED_FUNCALL

%   Elmar Zander
%   Copyright 2009, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


munit_set_function( 'cached_funcall' );

filename1=tempname;
filename2=tempname;

% should compute new
[d,e]=cached_funcall( @test_it_v1, {2,3,4}, 2, filename1, 1 );
assert_equals( [5, 12], [d,e], 'call' );

% should not call again, but get from file
[d,e]=cached_funcall( @test_it_no_call, {2,3,4}, 2, filename1, 1 );
assert_equals( [5, 12], [d,e], 'nocall' );

% version change => recompute
[d,e]=cached_funcall( @test_it_v2, {2,3,4}, 2, filename1, 2 );
assert_equals( [6, 14], [d,e], 'ver_change' );

% param change => recompute
[d,e]=cached_funcall( @test_it_v2, {2,3,5}, 2, filename1, 2 );
assert_equals( [6, 17], [d,e], 'param_change' );

% new filename (leave the version as is) => recompute
[d,e]=cached_funcall( @test_it_v1, {2,3,5}, 2, filename2, 2 );
assert_equals( [5, 15], [d,e], 'new_file' );

% no change in file 1
[d,e]=cached_funcall( @test_it_no_call, {2,3,5}, 2, filename1, 2 );
assert_equals( [6, 17], [d,e], 'old_file_unchanged' );

% no change in file 2
[d,e]=cached_funcall( @test_it_no_call, {2,3,5}, 2, filename2, 2 );
assert_equals( [5, 15], [d,e], 'new_file_unchanged' );

% no change in file 2
[d,e]=cached_funcall( @test_it_v3, {2,3,5}, 2, filename2, 3 );
assert_equals( [6, 18], [d,e], 'new_file_v3' );


s=warning('off', 'MATLAB:DELETE:FileNotFound' );
delete( sprintf('%s.mat', filename1 ) );
delete( sprintf('%s.mat', filename2 ) );
warning(s);

function [d,e]=test_it_v1( a, b, c )
d=a+b; e=b*c;

function [d,e]=test_it_v2( a, b, c )
d=a+b+1; e=b*c+2;

function [d,e]=test_it_v3( a, b, c )
d=a+b+1; e=b*c+3;

function [d,e]=test_it_no_call( a, b, c )
d=a+b+nan; e=c+nan;
