function unittest_matern_covariance
% UNITTEST_MATERN_COVARIANCE Test the MATERN_COVARIANCE function.
%
% Example (<a href="matlab:run_example unittest_matern_covariance">run</a>)
%   unittest_matern_covariance
%
% See also MATERN_COVARIANCE, TESTSUITE 

%   Elmar Zander
%   Copyright 2013, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'matern_covariance' );


% should be same as Gaussian 
x=linspace(0.2,1,10);
assert_equals( matern_covariance(100, x), exp(-x.^2/2), 'simple', 'abstol', 0.01 );

