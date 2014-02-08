function unittest_spatial_function
% UNITTEST_SPATIAL_FUNCTION Test the SPATIAL_FUNCTION function.
%
% Example (<a href="matlab:run_example unittest_spatial_function">run</a>)
%   unittest_spatial_function
%
% See also SPATIAL_FUNCTION, MUNIT_RUN_TESTSUITE 

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

munit_set_function( 'spatial_function' );

N=30;
x=rand(N,1);
y=rand(N,1);
z=rand(N,1);
null=zeros(N,1);
pos1=x'; pos2=[x';y']; pos3=[x';y';z'];

% check defaults for 'zero' mode
assert_equals( spatial_function( 'x', pos1, 'mode', 'zero'), x, 'zero_x1' );
assert_equals( spatial_function( 'y', pos1, 'mode', 'zero'), null, 'zero_y1' );
assert_equals( spatial_function( 'z', pos1, 'mode', 'zero'), null, 'zero_z1' );
assert_equals( spatial_function( 'x', pos2, 'mode', 'zero'), x, 'zero_x2' );
assert_equals( spatial_function( 'y', pos2, 'mode', 'zero'), y, 'zero_y2' );
assert_equals( spatial_function( 'z', pos2, 'mode', 'zero'), null, 'zero_z2' );
assert_equals( spatial_function( 'x', pos3, 'mode', 'zero'), x, 'zero_x3' );
assert_equals( spatial_function( 'y', pos3, 'mode', 'zero'), y, 'zero_y3' );
assert_equals( spatial_function( 'z', pos3, 'mode', 'zero'), z, 'zero_z3' );

% check defaults for 'last' mode
assert_equals( spatial_function( 'x', pos1, 'mode', 'last'), x, 'last_x1' );
assert_equals( spatial_function( 'y', pos1, 'mode', 'last'), x, 'last_y1' );
assert_equals( spatial_function( 'z', pos1, 'mode', 'last'), x, 'last_z1' );
assert_equals( spatial_function( 'x', pos2, 'mode', 'last'), x, 'last_x2' );
assert_equals( spatial_function( 'y', pos2, 'mode', 'last'), y, 'last_y2' );
assert_equals( spatial_function( 'z', pos2, 'mode', 'last'), y, 'last_z2' );
assert_equals( spatial_function( 'x', pos3, 'mode', 'last'), x, 'last_x3' );
assert_equals( spatial_function( 'y', pos3, 'mode', 'last'), y, 'last_y3' );
assert_equals( spatial_function( 'z', pos3, 'mode', 'last'), z, 'last_z3' );

% check some function
assert_equals( spatial_function( 'x*z', pos3), x.*z, 'xz' );
assert_equals( spatial_function( 'sin(y)', pos3), sin(y), 'siny' );
assert_equals( spatial_function( 'x/y+cos(z^2)', pos3), x./y+cos(z.^2), 'fxyz' );
assert_equals( spatial_function( 'x.*z', pos3), x.*z, 'xz2' );

% check some function (which contain x,y or z in the name)
assert_equals( spatial_function( 'y*hypot(x,y)*z', pos3), y.*hypot(x,y).*z, 'hypot' );
assert_equals( spatial_function( 'zeros(size(x))', pos3), null, 'zeros' );

% check with constants
assert_equals( spatial_function( '0', pos3), null, 'const0' );
assert_equals( spatial_function( '1', pos3), ones(size(x)), 'const1' );
assert_equals( spatial_function( '1.53e2', pos3), 153*ones(size(x)), 'const153' );

assert_equals( spatial_function( 'false', pos3), logical(null), 'logical' );


