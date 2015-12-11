function unittest_beta_distribution
% UNITTEST_BETA_DISTRIBUTION Test the distribution functions.
%
% Example (<a href="matlab:run_example unittest_beta_distribution">run</a>)
%    unittest_beta_distribution
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


%% beta_cdf
munit_set_function('beta_cdf');
a=2; b=3;
assert_equals( beta_cdf(-inf,a,b), 0, 'cdf_minf' );
assert_equals( beta_cdf(-1e8,a,b), 0, 'cdf_zero' );
assert_equals( beta_cdf(1+1e8,a,b), 1, 'cdf_zero' );
assert_equals( beta_cdf(inf,a,b), 1, 'cdf_inf' );
assert_equals( beta_cdf(1/2,a,a), 1/2, 'cdf_median' );
assert_equals( beta_cdf(1/2,b,b), 1/2, 'cdf_median' );
assert_equals( beta_cdf(1/2,1/b,1/b), 1/2, 'cdf_median' );


%% beta_pdf
munit_set_function('beta_pdf');
assert_equals( beta_pdf(-inf,a,b), 0, 'pdf_minf' );
assert_equals( beta_pdf(-1e8,a,b), 0, 'pdf_zero' );
assert_equals( beta_pdf(0,a,b), 0, 'pdf_zero' );
assert_equals( beta_pdf(1,a,b), 0, 'pdf_zero' );
assert_equals( beta_pdf(1+1e8,a,b), 0, 'pdf_zero' );
assert_equals( beta_pdf(inf,a,b), 0, 'pdf_inf' );

a=0.2;b=0.5;
assert_equals( beta_pdf(0,a,b), inf, 'pdf_zero' );
assert_equals( beta_pdf(1,a,b), inf, 'pdf_zero' );

% pdf matches cdf
a=2; b=3;
[x2,x]=linspace_midpoints(-0.1,1.1);
F=beta_cdf(x,a,b);
F2=pdf_integrate( beta_pdf(x2,a,b), F, x);
assert_equals( F, F2, 'pdf_cdf_match', struct('abstol',0.01) );


%% beta_invcdf
munit_set_function( 'beta_invcdf' );

y = linspace(0, 1);
x = linspace(0, 1);

params = {2, 3};
assert_equals( beta_cdf(beta_invcdf(y, params{:}), params{:}), y, 'cdf_invcdf_1');
assert_equals( beta_invcdf(beta_cdf(x, params{:}), params{:}), x, 'invcdf_cdf_1');
assert_equals( isnan(beta_invcdf([-0.1, 1.1], params{:})), [true, true], 'invcdf_nan1');

params = {0.5, 0.5};
assert_equals( beta_cdf(beta_invcdf(y, params{:}), params{:}), y, 'cdf_invcdf_2');
assert_equals( beta_invcdf(beta_cdf(x, params{:}), params{:}), x, 'invcdf_cdf_2');
assert_equals( isnan(beta_invcdf([-0.1, 1.1], params{:})), [true, true], 'invcdf_nan2');

params = {1, 1};
assert_equals( beta_cdf(beta_invcdf(y, params{:}), params{:}), y, 'cdf_invcdf_3');
assert_equals( beta_invcdf(beta_cdf(x, params{:}), params{:}), x, 'invcdf_cdf_3');
assert_equals( isnan(beta_invcdf([-0.1, 1.1], params{:})), [true, true], 'invcdf_nan3');


%% beta_stdnor
munit_set_function( 'beta_stdnor' );
N=50;
uni=linspace(0,1,N+2)';
uni=uni(2:end-1);
gam=sqrt(2)*erfinv(2*uni-1);

params={.5,1.3};
x=beta_stdnor( gam, params{:} );
assert_equals( beta_cdf(x, params{:}), uni, 'beta' )


%% beta_raw_moments
munit_set_function( 'beta_raw_moments' );

expected=[ 1.0, 0.5, 0.33333333333333331, 0.25, 0.20000000000000001, ...
    0.16666666666666666, 0.14285714285714285, 0.125, 0.1111111111111111, ...
    0.10000000000000001, 0.090909090909090912];
assert_equals( expected, beta_raw_moments( 0:10, 1, 1 ), 'a1b1' );

expected=[1.0, 0.33333333333333331, 0.14285714285714285, ...
      0.071428571428571425, 0.03968253968253968, 0.023809523809523808];
assert_equals( expected(1+[3;1;5])', beta_raw_moments( [3;1;5], 2, 4 ), 'a2b4T' );
