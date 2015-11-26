function unittest_NormalDistribution
% UNITTEST_NORMALDISTRIBUTION Test the NORMALDISTRIBUTION function.
%
% Example (<a href="matlab:run_example unittest_NormalDistribution">run</a>)
%   unittest_NormalDistribution
%
% See also NORMALDISTRIBUTION, MUNIT_RUN_TESTSUITE 

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

munit_set_function( 'NormalDistribution' );

%% Initialization
N=NormalDistribution(2,3);
assert_equals( N.mu, 2, 'Initialization default mu' );
assert_equals( N.sigma,3, 'Initialization default sigma' );

N=NormalDistribution(2);
assert_equals( N.mu, 2, 'Initialization default mu' );
assert_equals( N.sigma, 1, 'Initialization default sigma' );

N=NormalDistribution();
assert_equals( N.mu, 0, 'Initialization default mu' );
assert_equals( N.sigma, 1, 'Initialization default sigma' );

%% Mean & Var
assert_equals(N.mean, 0, 'mean');
assert_equals(N.var, 1, 'var' );

%% Moments
N=NormalDistribution(1.2, 2.3);
m_act = {1, 0, 0, 0, 0};
[m_act{2:end}] = N.moments();
m_ex = compute_moments(N);
assert_equals(m_act, m_ex, 'moments' );

%% normal_cdf
N=NormalDistribution(1,2);
assert_equals(cdf(N,-inf), 0, 'cdf_minf' );
assert_equals(cdf(N,inf), 1, 'cdf_inf' );
assert_equals(cdf(N,N.mu), 1/2, 'cdf_median' );

%% normal_pdf
N=NormalDistribution(1,2);
assert_equals( pdf(N,-inf), 0, 'pdf_minf' );
assert_equals(pdf(N,inf), 0, 'pdf_inf' );

%% normal_invcdf

y = linspace(0, 1);
x = linspace(-2, 3);

N=NormalDistribution();
assert_equals(cdf(N,invcdf(N,y)), y, 'cdf_invcdf_1');
assert_equals(invcdf(N,cdf(N,x)), x, 'invcdf_cdf_1');
assert_equals( isnan(invcdf(N,[-0.1, 1.1])), [true, true], 'invcdf_nan1');

N=NormalDistribution(0.5);
assert_equals(cdf(N,invcdf(N,y)), y, 'cdf_invcdf_2');
assert_equals(invcdf(N,cdf(N,x)), x, 'invcdf_cdf_2');
assert_equals( isnan(invcdf(N,[-0.1, 1.1])), [true, true], 'invcdf_nan2');

N=NormalDistribution(0.7,1.5);
assert_equals(cdf(N,invcdf(N,y)), y, 'cdf_invcdf_3');
assert_equals(invcdf(N,cdf(N,x)), x, 'invcdf_cdf_3');
assert_equals( isnan(invcdf(N,[-0.1, 1.1])), [true, true], 'invcdf_nan3');

%% Sample
munit_control_rand('seed', 1234);
N=NormalDistribution(0.7,1.5);
Ni=100000;
xi=N.sample(Ni);
assert_equals(N.cdf(sort(xi)), linspace_midpoints(0,1,Ni)', 'sample_cdf', 'abstol', 1e-2)


%% normal_stdnor
N=50;
uni=linspace(0,1,N+2)';
uni=uni(2:end-1);
gam=sqrt(2)*erfinv(2*uni-1);

N=NormalDistribution(0.2,0.3);
x=stdnor( N,gam );
assert_equals( cdf(N,x), uni, 'normal' )
N=NormalDistribution(0,1);
assert_equals( normal_stdnor(gam), stdnor(N,gam), 'normal_def12');
assert_equals( normal_stdnor(gam, 0),stdnor(N,gam), 'normal_def2');

%% translate
N=NormalDistribution(2,3);
%T=TranslatedDistribution(N,2,3);
tN=N.translate(2,3);
[m,v]=tN.moments();
%[m2,v2]=T.moments();
assert_equals( m, 4, 'translated mean');
assert_equals( v, 81, 'translated var');
assert_equals(tN.pdf(0),0.0401582,'translated pdf');
assert_equals(tN.pdf(inf),0,'translated pdf');
%T.pdf(0);
assert_equals(tN.cdf(0),0.328360,'translated cdf','abstol',0.0001);
assert_equals(tN.cdf(inf),1,'translated cdf');
assert_equals(tN.cdf(-inf),0,'translated cdf');
assert_equals(tN.invcdf(0),-inf,'translated cdf');

%% Fix Moments
% can test directly for the normal and uniform distributions
N = NormalDistribution(2,5);
dist=fix_moments(N,7,13);
[m,v]=moments(dist);
assert_equals(m,7,'mean fix_moments');
assert_equals(v,13,'var fix_moments');

%% Fix Bounds
N = NormalDistribution(2,3);
dist = fix_bounds(N,2,4,'q0',0.001,'q1', 0.5);
assert_equals(invcdf(dist,0.001), 2, 'fix_bounds-nor_min');
assert_equals(invcdf(dist,0.5), 4, 'fix_bounds-nor_max');

assert_error(@()(fix_bounds(N, 2, 4, 'q0',0,'q1', 0.5)), 'sglib:', 'lower_bound_inf');
assert_error(@()(fix_bounds(N, 2, 4, 'q0',0,'q1', 1)), 'sglib:', 'upper_bound_inf');

%% Orthogonal polynomials
dist = NormalDistribution();
polysys = dist.orth_polysys();
N = 5;
assert_equals(compute_gramian(polysys, dist, N), diag(polysys.sqnorm(0:N)), 'orth');

dist = NormalDistribution(2,3);
assert_error(@()(dist.orth_polysys()), 'sglib:', 'no_standard_dist');

%% Base dist stuff
dist = NormalDistribution(2, 3);
base = dist.get_base_dist();

assert_equals(base, NormalDistribution(0,1), 'base');

z = linspace(0,1);
x1 = dist.invcdf(z);
x2 = base.invcdf(z);
assert_equals(dist.base2dist(x2), x1, 'base2dist');
assert_equals(dist.dist2base(x1), x2, 'dist2base');
