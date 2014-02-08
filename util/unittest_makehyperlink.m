function unittest_makehyperlink
% UNITTEST_MAKEHYPERLINK Test the MAKEHYPERLINK function.
%
% Example (<a href="matlab:run_example unittest_makehyperlink">run</a>)
%   unittest_makehyperlink
%
% See also MAKEHYPERLINK, MUNIT_RUN_TESTSUITE 

%   Elmar Zander
%   Copyright 2010, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'makehyperlink' );

s=makehyperlink( 'run', 'run_example plotnd', 'command' );
s2='<a href="matlab:run_example plotnd">run</a>';
assert_equals( rep(s), rep(s2), 'command1' );


s=makehyperlink( 'plotnd', 'util/plotnd.m', 'file', 10, 3 );
s2='<a href="error:util/plotnd.m,10,3">plotnd at line 10</a>';
assert_equals( rep(s), rep(s2), 'file1' );

s=makehyperlink( 'plotnd', 'util/plotnd.m', 'file', 10 );
s2='<a href="error:util/plotnd.m,10,1">plotnd at line 10</a>';
assert_equals( rep(s), rep(s2), 'file2' );

s=makehyperlink( 'plotnd', 'util/plotnd.m', 'file' );
s2='<a href="error:util/plotnd.m,1,1">plotnd</a>';
assert_equals( rep(s), rep(s2), 'file3' );


s=makehyperlink( 'this article', 'http://dx.doi.org/12345', 'url' );
s2='<a href="http://dx.doi.org/12345">this article</a>';
assert_equals( rep(s), rep(s2), 'url1' );

s=makehyperlink( 'this article', 'dx.doi.org/12345', 'url' );
s2='<a href="http://dx.doi.org/12345">this article</a>';
assert_equals( rep(s), rep(s2), 'url2' );


function s=rep( s )
s=strrep( s, '<a', '< \ba');
s=strrep( s, '</', '< \b/');
s=sprintf(s);
