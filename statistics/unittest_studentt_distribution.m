function unittest_studentt_distribution
% UNITTEST_STUDENTT_DISTRIBUTION Test the distribution functions.
%
% Example (<a href="matlab:run_example unittest_studentt_distribution">run</a>)
%    unittest_studentt_distribution
%
% See also TESTSUITE

%   Elmar Zander
%   Copyright 2007, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

%% studentt_cdf
nu=4;
munit_set_function('studentt_cdf');
assert_equals( studentt_cdf(-inf,nu), 0, 'cdf_minf' );
assert_equals( studentt_cdf(-1e10,nu), 0, 'cdf_negative' );
assert_equals( studentt_cdf(inf,nu), 1, 'cdf_inf' );
assert_equals( studentt_cdf(0,nu), 1/2, 'cdf_median' );

% computed with stat toolbox
x = [-2, -1, -0.5, 0, 1];
cdf_ex = [0.069662984279422   0.195501109477885   0.325723982424076   0.500000000000000   0.804498890522115];
assert_equals( studentt_cdf(x, 3), cdf_ex, 'cdf_sttb');

%% studentt_pdf
munit_set_function('studentt_pdf');
assert_equals( studentt_pdf(-inf,nu), 0, 'pdf_minf' );
assert_equals( studentt_pdf(inf,nu), 0, 'pdf_inf' );

% computed with stat toolbox
x = [-2, -1, -0.5, 0, 1];
cdf_ex = [0.067509660663893   0.206748335783172   0.313180911008829   0.367552596947861   0.206748335783172];
assert_equals( studentt_pdf(x, 3), cdf_ex, 'cdf_sttb');


% pdf matches cdf
[x1,x2]=linspace_mp( -15, 3, 1000 );
F=studentt_cdf( x1, nu );
F2=pdf_integrate( studentt_pdf( x2, nu ), F, x1);
assert_equals( F, F2, 'pdf_cdf_match', struct('abstol',0.01) );

%% studentt_invcdf
munit_set_function( 'studentt_invcdf' );

y = linspace(0, 1);
params = {2};
assert_equals( studentt_cdf(studentt_invcdf(y, params{:}), params{:}), y, 'cdf_invcdf_1');
assert_equals( studentt_invcdf(studentt_cdf(y, params{:}), params{:}), y, 'invcdf_cdf_1');
assert_equals( isnan(studentt_invcdf([-0.1, 1.1], params{:})), [true, true], 'invcdf_nan1');

params = {10};
assert_equals( studentt_cdf(studentt_invcdf(y, params{:}), params{:}), y, 'cdf_invcdf_2');
assert_equals( studentt_invcdf(studentt_cdf(y, params{:}), params{:}), y, 'invcdf_cdf_2');
assert_equals( isnan(studentt_invcdf([-0.1, 1.1], params{:})), [true, true], 'invcdf_nan2');

