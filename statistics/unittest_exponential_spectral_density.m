function unittest_exponential_spectral_density(varargin)
% UNITTEST_EXPONENTIAL_SPECTRAL_DENSITY Test the EXPONENTIAL_SPECTRAL_DENSITY function.
%
% Example (<a href="matlab:run_example unittest_exponential_spectral_density">run</a>)
%   unittest_exponential_spectral_density
%
% See also EXPONENTIAL_SPECTRAL_DENSITY, MUNIT_RUN_TESTSUITE 

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

munit_set_function( 'exponential_spectral_density' );

% Some computed values (scalar and one vector valued)
assert_equals( exponential_spectral_density(4, 3, 1), (2*3) / (1 + 4 * pi * pi * 9 * 16));
assert_equals( exponential_spectral_density([4 5], 3, 1), (2*3) ./ (1 + 4 * pi * pi * 9 * [16 25]));
assert_equals( exponential_spectral_density(4, 3, 3), (2*3)^3 * pi / (1 + 4 * pi * pi * 9 * 16)^2);

% Default for d (in the second example, note that 2^2+3^2+6^2=7^2,
% see https://en.wikipedia.org/wiki/Pythagorean_quadruple)
assert_equals( exponential_spectral_density(4, 3), (2*3) / (1 + 4 * pi * pi * 9 * 16));
assert_equals( exponential_spectral_density([1 2;2 3;2 6], 5), (2*5)^3 * pi ./ (1 + 4 * pi * pi * 25 * [9 49]).^2);
