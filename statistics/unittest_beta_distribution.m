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


a=2; b=3;
munit_set_function('beta_cdf');
assert_equals( beta_cdf(-inf,a,b), 0, 'cdf_minf' );
assert_equals( beta_cdf(-1e8,a,b), 0, 'cdf_zero' );
assert_equals( beta_cdf(1+1e8,a,b), 1, 'cdf_zero' );
assert_equals( beta_cdf(inf,a,b), 1, 'cdf_inf' );
assert_equals( beta_cdf(1/2,a,a), 1/2, 'cdf_median' );
assert_equals( beta_cdf(1/2,b,b), 1/2, 'cdf_median' );
assert_equals( beta_cdf(1/2,1/b,1/b), 1/2, 'cdf_median' );

munit_set_function('beta_pdf');
assert_equals( beta_pdf(-inf,a,b), 0, 'pdf_minf' );
assert_equals( beta_pdf(-1e8,a,b), 0, 'pdf_zero' );
assert_equals( beta_pdf(0,a,b), 0, 'pdf_zero' );
assert_equals( beta_pdf(1,a,b), 0, 'pdf_zero' );
assert_equals( beta_pdf(1+1e8,a,b), 0, 'pdf_zero' );
assert_equals( beta_pdf(inf,a,b), 0, 'pdf_inf' );

a=0.2;b=0.5;
assert_equals( beta_pdf(0,a,b), 0, 'pdf_zero' );
assert_equals( beta_pdf(1,a,b), 0, 'pdf_zero' );

a=2; b=3;
[x,x2]=linspace_mp(-0.1,1.1);
F=beta_cdf(x,a,b);
F2=pdf_integrate( beta_pdf(x2,a,b), F, x);
assert_equals( F, F2, 'pdf_cdf_match', struct('abstol',0.01) );



% stdnor
N=50;
uni=linspace(0,1,N+2)';
uni=uni(2:end-1);
gam=sqrt(2)*erfinv(2*uni-1);

munit_set_function( 'beta_stdnor' );
params={.5,1.3};
x=beta_stdnor( gam, params{:} );
assert_equals( beta_cdf(x, params{:}), uni, 'beta' )

%% invcdf
x = linspace(0, 1);
params = {2, 3};
assert_equals( beta_cdf(beta_invcdf(x, params{:}), params{:}), x, 'cdf_invcdf_1');
assert_equals( beta_invcdf(beta_cdf(x, params{:}), params{:}), x, 'invcdf_cdf_1');
assert_equals( isnan(beta_invcdf([-0.1, 1.1], params{:})), [true, true], 'invcdf_nan1');

params = {0.5, 0.5};
assert_equals( beta_cdf(beta_invcdf(x, params{:}), params{:}), x, 'cdf_invcdf_1');
assert_equals( beta_invcdf(beta_cdf(x, params{:}), params{:}), x, 'invcdf_cdf_1');
assert_equals( isnan(beta_invcdf([-0.1, 1.1], params{:})), [true, true], 'invcdf_nan1');

params = {1, 1};
assert_equals( beta_cdf(beta_invcdf(x, params{:}), params{:}), x, 'cdf_invcdf_1');
assert_equals( beta_invcdf(beta_cdf(x, params{:}), params{:}), x, 'invcdf_cdf_1');
assert_equals( isnan(beta_invcdf([-0.1, 1.1], params{:})), [true, true], 'invcdf_nan1');


