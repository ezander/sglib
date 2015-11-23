function unittest_exponential_distribution
% UNITTEST_EXPONENTIAL_DISTRIBUTION Test the distribution functions.
%
% Example (<a href="matlab:run_example unittest_exponential_distribution">run</a>)
%    unittest_exponential_distribution
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

%% exponential_cdf
alpha=1.5;
munit_set_function('exponential_cdf');
assert_equals( exponential_cdf(-inf,alpha), 0, 'cdf_minf' );
assert_equals( exponential_cdf(-1e10,alpha), 0, 'cdf_negative' );
assert_equals( exponential_cdf(inf,alpha), 1, 'cdf_inf' );
assert_equals( exponential_cdf(log(2)/alpha,alpha), 1/2, 'cdf_median' );


%% exponential_pdf
munit_set_function('exponential_pdf');
assert_equals( exponential_pdf(-inf,alpha), 0, 'pdf_minf' );
assert_equals( exponential_pdf(-1e10,alpha), 0, 'pdf_negative' );
assert_equals( exponential_pdf(inf,alpha), 0, 'pdf_inf' );

% pdf matches cdf
[x2,x1]=linspace_midpoints( -0.1, 5 );
F=exponential_cdf( x1, alpha );
F2=pdf_integrate( exponential_pdf( x2, alpha ), F, x1);
assert_equals( F, F2, 'pdf_cdf_match', struct('abstol',0.01) );

%% exponential_invcdf
munit_set_function( 'exponential_invcdf' );

y = linspace(0, 1);
params = {2};
assert_equals( exponential_cdf(exponential_invcdf(y, params{:}), params{:}), y, 'cdf_invcdf_1');
assert_equals( exponential_invcdf(exponential_cdf(y, params{:}), params{:}), y, 'invcdf_cdf_1');
assert_equals( isnan(exponential_invcdf([-0.1, 1.1], params{:})), [true, true], 'invcdf_nan1');

params = {0.5};
assert_equals( exponential_cdf(exponential_invcdf(y, params{:}), params{:}), y, 'cdf_invcdf_1');
assert_equals( exponential_invcdf(exponential_cdf(y, params{:}), params{:}), y, 'invcdf_cdf_1');
assert_equals( isnan(exponential_invcdf([-0.1, 1.1], params{:})), [true, true], 'invcdf_nan1');


%% exponential_stdnor
N=50;
uni=linspace(0,1,N+2)';
uni=uni(2:end-1);
gam=sqrt(2)*erfinv(2*uni-1);

munit_set_function( 'exponential_stdnor' );
params={.7};
x=exponential_stdnor( gam, params{:} );
assert_equals( exponential_cdf(x, params{:}), uni, 'exponential' )


%% exponential_raw_moments
munit_set_function( 'exponential_raw_moments' );

expected=[1., 0.7692307692307692, 1.1834319526627217, 2.7309968138370504, 8.403067119498616, 32.31948892114852];
assert_equals( expected, exponential_raw_moments( 0:5, 1.3 ), 'lam1.3' );

expected=[750;5;375000];
assert_equals( expected, exponential_raw_moments( [3;1;5], 0.2 ), 'lam0.2T' );
