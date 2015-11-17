function unittest_polysys_dist
% UNITTEST_POLYSYS_DIST Test the POLYSYS_DIST function.
%
% Example (<a href="matlab:run_example unittest_polysys_dist">run</a>)
%   unittest_polysys_dist
%
% See also POLYSYS_DIST, MUNIT_RUN_TESTSUITE 

%   Elmar Zander
%   Copyright 2014, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'polysys_dist' );

% Hermite/Gaussian
dist = polysys_dist('h');
assert_equals( class(polysys_dist('H')), class(dist), 'same_h');
assert_equals( gendist_invcdf([0, 1], dist), [-inf, inf], 'bounds_h');
[m1,m2,m3,m4] = gendist_moments(dist);
assert_equals( [m1,m2,m3,m4], [0, 1, 0, 0], 'moments_h');

% Legendre/Uniform
dist = polysys_dist('p');
assert_equals( class(polysys_dist('P')), class(dist), 'same_p');
assert_equals( gendist_invcdf([0, 1], dist), [-1, 1], 'bounds_p');
[m1,m2,m3,m4] = gendist_moments(dist);
assert_equals( [m1,m2,m3,m4], [0, 1/3, 0, -6/5], 'moments_h');

% ChebyshevT/Arcsine
dist = polysys_dist('t');
assert_equals( class(polysys_dist('T')), class(dist), 'same_t');
assert_equals( gendist_invcdf([0, 1], dist), [-1, 1], 'bounds_t');
[m1,m2,m3,m4] = gendist_moments(dist);
assert_equals( [m1,m2,m3,m4], [0, 1/2, 0, -3/2], 'moments_t');

% ChebyshevU/Semicircle
dist = polysys_dist('u');
assert_equals( class(polysys_dist('U')), class(dist), 'same_u');
assert_equals( gendist_invcdf([0, 1], dist), [-1, 1], 'bounds_u');
[m1,m2,m3,m4] = gendist_moments(dist);
assert_equals( [m1,m2,m3,m4], [0, 1/4, 0, -1], 'moments_u');

% Laguerre/Exponential
dist = polysys_dist('l');
assert_equals( class(polysys_dist('L')), class(dist), 'same_l');
assert_equals( gendist_invcdf([0, 1], dist), [0, inf], 'bounds_l');
[m1,m2,m3,m4] = gendist_moments(dist);
assert_equals( [m1,m2,m3,m4], [1, 1, 2, 6], 'moments_l');
