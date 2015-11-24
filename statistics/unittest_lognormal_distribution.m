function unittest_lognormal_distribution
% UNITTEST_LOGNORMAL_DISTRIBUTION Test the distribution functions.
%
% Example (<a href="matlab:run_example unittest_lognormal_distribution">run</a>)
%    unittest_lognormal_distribution
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

%% lognormal_cdf
munit_set_function('lognormal_cdf');
mu=2; sig=0.5;
assert_equals( lognormal_cdf(-inf,mu,sig), 0, 'cdf_minf' );
assert_equals( lognormal_cdf(-1e8,mu,sig), 0, 'cdf_negative' );
assert_equals( lognormal_cdf(inf,mu,sig), 1, 'cdf_inf' );
assert_equals( lognormal_cdf(exp(mu),mu,sig), 1/2, 'cdf_median' );

% default arguments
x = linspace(-0.5, 4.3);
assert_equals( lognormal_cdf(x), lognormal_cdf(x,0,1), 'cdf_def12' );
assert_equals( lognormal_cdf(x,-0.2), lognormal_cdf(x,-0.2,1), 'cdf_def2' );


%% lognormal_pdf
munit_set_function('lognormal_pdf');
assert_equals( lognormal_pdf(-inf,mu,sig), 0, 'pdf_minf' );
assert_equals( lognormal_pdf(-1e8,mu,sig), 0, 'pdf_negative' );
assert_equals( lognormal_pdf(inf,mu,sig), 0, 'pdf_inf' );

% pdf matches cdf
[x2,x1]=linspace_midpoints(0,exp(mu+5*sig));
F=lognormal_cdf(x1, mu, sig);
F2=pdf_integrate( lognormal_pdf(x2,mu,sig), F, x1);
assert_equals( F, F2, 'pdf_cdf_match', struct('abstol',0.01) );

% default arguments
x = linspace(-0.5, 4.3);
assert_equals( lognormal_pdf(x), lognormal_pdf(x,0,1), 'pdf_def12' );
assert_equals( lognormal_pdf(x,-0.2), lognormal_pdf(x,-0.2,1), 'pdf_def2' );


%% lognormal_invcdf
munit_set_function( 'lognormal_invcdf' );

y = linspace(0, 1);
x = linspace(0, 10);

params = {};
assert_equals( lognormal_cdf(lognormal_invcdf(y, params{:}), params{:}), y, 'cdf_invcdf_1');
assert_equals( lognormal_invcdf(lognormal_cdf(x, params{:}), params{:}), x, 'invcdf_cdf_1');
assert_equals( isnan(lognormal_invcdf([-0.1, 1.1], params{:})), [true, true], 'invcdf_nan1');

params = {0.5};
assert_equals( lognormal_cdf(lognormal_invcdf(y, params{:}), params{:}), y, 'cdf_invcdf_2');
assert_equals( lognormal_invcdf(lognormal_cdf(x, params{:}), params{:}), x, 'invcdf_cdf_2');
assert_equals( isnan(lognormal_invcdf([-0.1, 1.1], params{:})), [true, true], 'invcdf_nan2');

params = {0.7, 1.5};
assert_equals( lognormal_cdf(lognormal_invcdf(y, params{:}), params{:}), y, 'cdf_invcdf_3');
assert_equals( lognormal_invcdf(lognormal_cdf(x, params{:}), params{:}), x, 'invcdf_cdf_3');
assert_equals( isnan(lognormal_invcdf([-0.1, 1.1], params{:})), [true, true], 'invcdf_nan3');


%% lognormal_stdnor
munit_set_function( 'lognormal_stdnor' );
N=50;
uni=linspace(0,1,N+2)';
uni=uni(2:end-1);
gam=sqrt(2)*erfinv(2*uni-1);

params={.2,.3};
x=lognormal_stdnor( gam, params{:} );
assert_equals( lognormal_cdf(x, params{:}), uni, 'lognormal' )
assert_equals( lognormal_stdnor(gam), lognormal_stdnor(gam, 0, 1), 'lognormal_def12');
assert_equals( lognormal_stdnor(gam, 0), lognormal_stdnor(gam, 0, 1), 'lognormal_def2');


%% lognormal_raw_moments
munit_set_function( 'lognormal_raw_moments' );

% some precomputed moments
expected=[ 1., 1.6487212707001282, 7.38905609893065, 90.01713130052181, ...
    2980.9579870417283, 268337.2865208745, 6.565996913733051e7, ...
    4.3673179097646416e10, 7.896296018268069e13, 3.8808469624362035e17, ...
    5.184705528587072e21];
assert_equals( expected, lognormal_raw_moments( 0:10, 0, 1 ), 'mu0sig1' );


expected=[1.0, 3.472934799336826, 13.197138159658358, ...
    54.871824399070078, 249.63503718969369, 1242.6481670549958];
assert_equals( expected(1+[3,1,5])', lognormal_raw_moments( [3;1;5], 1.2, 0.3 ), 'mu12sig03' );


% test default arguments
assert_equals( lognormal_raw_moments(0:5), lognormal_raw_moments(0:5, 0, 1), 'def_12');
assert_equals( lognormal_raw_moments(0:5, -0.2), lognormal_raw_moments(0:5, -0.2, 1), 'def_2');
