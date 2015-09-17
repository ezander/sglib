function unittest_normal_distribution
% UNITTEST_NORMAL_DISTRIBUTION Test the distribution functions.
%
% Example (<a href="matlab:run_example unittest_normal_distribution">run</a>)
%    unittest_normal_distribution
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


%% normal_cdf
munit_set_function('normal_cdf');
mu=1; sig=2;
assert_equals( normal_cdf(-inf,mu,sig), 0, 'cdf_minf' );
assert_equals( normal_cdf(inf,mu,sig), 1, 'cdf_inf' );
assert_equals( normal_cdf(mu,mu,sig), 1/2, 'cdf_median' );

% default arguments
x = linspace(-0.5, 4.3);
assert_equals( normal_cdf(x), normal_cdf(x,0,1), 'cdf_def12' );
assert_equals( normal_cdf(x,0.2), normal_cdf(x,0.2,1), 'cdf_def2' );


%% normal_pdf
munit_set_function('normal_pdf');
assert_equals( normal_pdf(-inf,mu,sig), 0, 'pdf_minf' );
assert_equals( normal_pdf(inf,mu,sig), 0, 'pdf_inf' );

% pdf matches cdf
[x1,x2]=linspace_mp(mu-5*sig,mu+5*sig);
F=normal_cdf(x1, mu, sig);
F2=pdf_integrate( normal_pdf(x2,mu,sig), F, x1);
assert_equals( F, F2, 'pdf_cdf_match', struct('abstol',0.01) );

% default arguments
x = linspace(-0.5, 4.3);
assert_equals( normal_pdf(x), normal_pdf(x,0,1), 'pdf_def12' );
assert_equals( normal_pdf(x,0.2), normal_pdf(x,0.2,1), 'pdf_def2' );


%% normal_invcdf
munit_set_function( 'normal_invcdf' );

y = linspace(0, 1);
x = linspace(-2, 3);

params = {};
assert_equals( normal_cdf(normal_invcdf(y, params{:}), params{:}), y, 'cdf_invcdf_1');
assert_equals( normal_invcdf(normal_cdf(x, params{:}), params{:}), x, 'invcdf_cdf_1');
assert_equals( isnan(normal_invcdf([-0.1, 1.1], params{:})), [true, true], 'invcdf_nan1');

params = {0.5};
assert_equals( normal_cdf(normal_invcdf(y, params{:}), params{:}), y, 'cdf_invcdf_2');
assert_equals( normal_invcdf(normal_cdf(x, params{:}), params{:}), x, 'invcdf_cdf_2');
assert_equals( isnan(normal_invcdf([-0.1, 1.1], params{:})), [true, true], 'invcdf_nan2');

params = {0.7, 1.5};
assert_equals( normal_cdf(normal_invcdf(y, params{:}), params{:}), y, 'cdf_invcdf_3');
assert_equals( normal_invcdf(normal_cdf(x, params{:}), params{:}), x, 'invcdf_cdf_3');
assert_equals( isnan(normal_invcdf([-0.1, 1.1], params{:})), [true, true], 'invcdf_nan3');

%% normal_stdnor
munit_set_function( 'normal_stdnor' );
N=50;
uni=linspace(0,1,N+2)';
uni=uni(2:end-1);
gam=sqrt(2)*erfinv(2*uni-1);

params={.2,.3};
x=normal_stdnor( gam, params{:} );
assert_equals( normal_cdf(x, params{:}), uni, 'normal' )
assert_equals( normal_stdnor(gam), normal_stdnor(gam, 0, 1), 'normal_def12');
assert_equals( normal_stdnor(gam, 0), normal_stdnor(gam, 0, 1), 'normal_def2');

%% normal_raw_moments
munit_set_function( 'normal_raw_moments' );

% some precomputed moments
expected=[1, 0, 1, 0, 3, 0, 15, 0, 105, 0, 945];
assert_equals( expected, normal_raw_moments( 0:10, 0, 1 ), 'mu0sig1' );

expected=[-13, -1, -281];
assert_equals( expected, normal_raw_moments( [3;1;5], 1, 2 ), 'lam0.2T' );

% test default arguments
assert_equals( normal_raw_moments(0:5), normal_raw_moments(0:5, 0, 1), 'def_12');
assert_equals( normal_raw_moments(0:5, 0.4), normal_raw_moments(0:5, 0.4, 1), 'def_2');
