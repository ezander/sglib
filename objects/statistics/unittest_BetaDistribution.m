function unittest_BetaDistribution
% UNITTEST_BETADISTRIBUTION Test the BETADISTRIBUTION function.
%
% Example (<a href="matlab:run_example unittest_BetaDistribution">run</a>)
%   unittest_BetaDistribution
%
% See also BETADISTRIBUTION, MUNIT_RUN_TESTSUITE

%   Elmar Zander, Aidin Nojavan
%   Copyright 2014, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'BetaDistribution' );

%% Initialization
B = BetaDistribution(2,3);
assert_equals( B.a, 2, 'Initialization a' );
assert_equals( B.b, 3, 'Initialization b' );
assert_equals( B.tostring(), 'Beta(2, 3)', 'tostring');

%% Mean & Var
assert_equals( B.mean, -0.2, 'mean' );
assert_equals( B.var, 0.16, 'var' );

%% beta_cdf
B = BetaDistribution(2,3);
assert_equals(cdf(B,-inf),0, 'cdf_minf' );
assert_equals(cdf(B,-1-1e8), 0, 'cdf_zero' );
assert_equals( cdf(B, 1+1e8), 1, 'cdf_zero' );
assert_equals( cdf(B,inf), 1, 'cdf_inf' );
B = BetaDistribution(2,2);
assert_equals(cdf(B,0), 1/2, 'cdf_median' );
B = BetaDistribution(3,3);
assert_equals(cdf(B,0), 1/2, 'cdf_median' );
B = BetaDistribution(1/3,1/3);
assert_equals(cdf(B,0), 1/2, 'cdf_median' );

%% beta_pdf
B = BetaDistribution(2,3);
assert_equals( pdf(B,-inf), 0, 'pdf_minf' );
assert_equals( pdf(B,-1-1e8), 0, 'pdf_zero' );
assert_equals( pdf(B,-1), 0, 'pdf_zero' );
assert_equals( pdf(B,1), 0, 'pdf_zero' );
assert_equals( pdf(B,1+1e8), 0, 'pdf_zero' );
assert_equals( pdf(B,inf), 0, 'pdf_inf' );

B = BetaDistribution(0.2,0.5);
assert_equals(pdf(B,-1-1e-10), 0, 'pdf_zero' );
assert_equals(pdf(B,1+1e-10), 0, 'pdf_zero' );

%% beta_invcdf
y = linspace(0, 1);
x = linspace(-1, 1);

B = BetaDistribution(2,3);
assert_equals( cdf(B,invcdf(B,y)), y, 'cdf_invcdf_1');
assert_equals( invcdf(B,cdf(B,x)), x, 'invcdf_cdf_1', 'abstol', 1e-7);
assert_equals( isnan(invcdf(B,[-0.1, 1.1])), [true, true], 'invcdf_nan1');

B = BetaDistribution(0.5,0.5);
assert_equals( cdf(B,invcdf(B,y)), y, 'cdf_invcdf_2');
assert_equals(invcdf(B,cdf(B,x)), x, 'invcdf_cdf_2');
assert_equals( isnan(invcdf(B,[-0.1, 1.1])), [true, true], 'invcdf_nan2');

B = BetaDistribution(1,1);
assert_equals( cdf(B,invcdf(B,y)), y, 'cdf_invcdf_3');
assert_equals( invcdf(B,cdf(B,x)), x, 'invcdf_cdf_3');
assert_equals( isnan(invcdf(B,[-0.1, 1.1])), [true, true], 'invcdf_nan3');

%% Sample
munit_control_rand('seed', 1234);
B = BetaDistribution(2,3);
N=100000;
xi=B.sample(N);
assert_equals(B.cdf(sort(xi)), linspace_midpoints(0,1,N)', 'sample_cdf', 'abstol', 1e-2)

%% fix_moments
B=BetaDistribution(2,3);
dist=fix_moments(B,3,14);
[m,v]=moments(dist);
assert_equals(m,3,'mean fix_moments');
assert_equals(v,14,'var fix_moments');

%% Fix Bounds
B = BetaDistribution(2,3);
dist = fix_bounds(B,4,5);
assert_equals(invcdf(dist,0), 4, 'fix_bounds-uni_min');
assert_equals(invcdf(dist,1), 5, 'fix_bounds-uni_max');

%% Base dist stuff
dist = BetaDistribution(2, 3);
base = dist.get_base_dist();

assert_equals(base, BetaDistribution(2,3), 'base_is_same');

z = linspace(0,1);
x1 = dist.invcdf(z);
x2 = base.invcdf(z);
assert_equals(dist.base2dist(x2), x1, 'base2dist');
assert_equals(dist.dist2base(x1), x2, 'dist2base');

%% Ortho polys
dist = BetaDistribution(1.5, 0.5);
polysys = dist.orth_polysys();
N = 5;
%assert_equals(compute_gramian(polysys, dist, N), diag(polysys.sqnorm(0:N)), 'orth');
