function unittest_TranslatedDistribution
% UNITTEST_TRANSLATEDDISTRIBUTION Test the TRANSLATEDDISTRIBUTION function.
%
% Example (<a href="matlab:run_example unittest_TranslatedDistribution">run</a>)
%   unittest_TranslatedDistribution
%
% See also TRANSLATEDDISTRIBUTION, MUNIT_RUN_TESTSUITE 

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

munit_set_function( 'TranslatedDistribution' );

%% Initialization
N = NormalDistribution(0.4,0.2);
T = TranslatedDistribution(N,4,5);

assert_equals( T.shift, 4, 'Initialization shift' );
assert_equals( T.scale, 5, 'Initialization scale' );
assert_equals( T.center, 0.4, 'Initialization center=mean' );
assert_equals( T.tostring(), 'Translated(N(0.4, 0.04), 4, 5, 0.4)', 'tostring' );

T = TranslatedDistribution(N,4,5,1);
assert_equals( T.center, 1, 'Initialization center' );

%% Mean & Var
T = TranslatedDistribution(N,4,5);
assert_equals(T.mean,0.4 + 4, 'mean');
assert_equals(T.var, 0.04 * 25, 'var' );

T = TranslatedDistribution(N,4,5,1);
assert_equals(T.mean,(0.4-1)*5 + 4 + 1, 'mean');
assert_equals(T.var, 0.04 * 25, 'var' );

%% Moments
T = TranslatedDistribution(N, 4, 5, 1);
m_act = {1, 0, 0, 0, 0};
[m_act{2:end}] = T.moments();
m_ex = compute_moments(T);
assert_equals(m_act, m_ex, 'moments' );

%% PDF
LN = LogNormalDistribution(3,3);
T = TranslatedDistribution(LN,0.25,1);
assert_equals(pdf(T,1/2), 0.1826612, 'pdf_median','abstol',0.001);

%% CDF
LN = LogNormalDistribution(3,3);
T = TranslatedDistribution(LN,0.25,1);
assert_equals(cdf(T,1/2), 0.07185716, 'cdf_median');

%% INVCDF

%% Sample
munit_control_rand('seed', 1234);
E = ExponentialDistribution(1.3);
T = TranslatedDistribution(E,4,5,1);
N=100000;
xi=T.sample(N);
assert_equals(T.cdf(sort(xi)), linspace_midpoints(0,1,N)', 'sample_cdf', 'abstol', 1e-2)

%% Moments
N = NormalDistribution(4,1);
T = TranslatedDistribution(N,2,3,2);
[mean,var,skew,kurt]=moments(T);
assert_equals(mean, 10, 'moments1');
assert_equals(var, 9, 'moments2');
assert_equals(skew, 0, 'moments3');
assert_equals(kurt, 0, 'moments4');

%% Fix Moments
% can test directly for the normal and uniform distributions
N = NormalDistribution(2,5);
T = TranslatedDistribution(N,0,1);
dist=fix_moments(T,7,13);
assert_equals([dist.shift,dist.scale], [5, sqrt(13/25)], 'normal','abstol',0.0001);

% dist = gendist_create('uniform', {22, 88});
U = UniformDistribution(22,88);
T = TranslatedDistribution(U,0,1);
dist=fix_moments(T, 50, 3 );
assert_equals([dist.shift,dist.scale], [-5, 1/11], 'uniform');

% can test via the moments for the lognormal distribution
% dist=gendist_create('lognormal', {0,1});
LN=LogNormalDistribution(0,1);
T=TranslatedDistribution(LN,0,1);
dist=fix_moments(T, 3.1, 2.4 );
[mean,var]=moments( dist );
assert_equals( mean, 3.1, 'mean' );
assert_equals( var, 2.4, 'var' );

% change a second time
dist=fix_moments( dist, 7, 5 );
[mean,var]=moments( dist );
assert_equals( mean, 7, 'mean2' );
assert_equals( var, 5, 'var2' );

%% Fix Bounds
% test for the uniform distribution
U = UniformDistribution(2,3);
T = TranslatedDistribution(U,3,0.5);
dist = fix_bounds(T,2,4);
assert_equals(invcdf(dist,0), 2, 'fix_bounds-uni_min');
assert_equals(invcdf(dist,1), 4, 'fix_bounds-uni_max');

% test with quantiles for the normal distribution
N = NormalDistribution(2,3);
T = TranslatedDistribution(N,0,1,2);
dist = fix_bounds(T,2,4,'q0',0.001,'q1', 0.5);
assert_equals(invcdf(dist,0.001), 2, 'fix_bounds-nor_min');
assert_equals(invcdf(dist,0.5), 4, 'fix_bounds-nor_max');
