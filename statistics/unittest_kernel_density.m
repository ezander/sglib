function unittest_kernel_density
% UNITTEST_KERNEL_DENSITY Test the KERNEL_DENSITY function.
%
% Example (<a href="matlab:run_example unittest_kernel_density">run</a>)
%   unittest_kernel_density
%
% See also KERNEL_DENSITY, MUNIT_RUN_TESTSUITE 

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

munit_set_function( 'kernel_density' );

% Since this is only some estimation we cannot make sure that we have the
% true pdf, however for a known distribution we should be near to it...

N=100000;
xn=[randn(N,1), 2*rand(N,1)-2];
[x,p]=kernel_density( xn, 30, 0.1 );

assert_equals( p(:,1), normal_pdf( x(:,1), 0, 1 ), 'normal', 'abstol', 0.02, 'fuzzy', true ); 
% remark: performs pretty bad for distributions with jumps like the uniform
% distribution since it is smoothing there too much)
assert_equals( p(:,2), uniform_pdf( x(:,2), -2, 0 ), 'uniform', 'abstol', 0.2, 'fuzzy', true ); 

% this checks for the existence of a bug that overwrote the value of n and
% caused kernel_density to become very slow for large data sets
xn = rand(120,1);
[x,p]=kernel_density(xn, 27);
assert_equals(size(x), [27,1], 'size');
