function unittest_gaussian_spectral_density(varargin)
% UNITTEST_GAUSSIAN_SPECTRAL_DENSITY Test the GAUSSIAN_SPECTRAL_DENSITY function.
%
% Example (<a href="matlab:run_example unittest_gaussian_spectral_density">run</a>)
%   unittest_gaussian_spectral_density
%
% See also GAUSSIAN_SPECTRAL_DENSITY, MUNIT_RUN_TESTSUITE 

%   Elmar Zander
%   Copyright 2015, Inst. of Scientific Computing
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'gaussian_spectral_density' );

% Some computed values (scalar and one vector valued)
assert_equals( gaussian_spectral_density(4, 3, 1), 3 * sqrt(pi) * exp(- pi * pi * 9 * 16), 'd=1');
assert_equals( gaussian_spectral_density([4, 5], 3, 1), 3 * sqrt(pi) * exp(- pi * pi * 9 * [16, 25]), 'vec');
assert_equals( gaussian_spectral_density(4, 3, 3), 27 * sqrt(pi^3) * exp(- pi * pi * 9 * 16), 'd=3');

% Default for d (in the second example, note that 2^2+3^2+6^2=7^2,
% see https://en.wikipedia.org/wiki/Pythagorean_quadruple)
assert_equals( gaussian_spectral_density(4, 3), 3 * sqrt(pi) * exp(- pi * pi * 9 * 16), 'default, d=1');
assert_equals( gaussian_spectral_density([1 2;2 3;2 6], 5), 3 * sqrt(pi) * exp(- pi * pi * 9 * [9, 49]), 'default, d=3');
