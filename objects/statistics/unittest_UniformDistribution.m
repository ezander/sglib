function unittest_UniformDistribution
% UNITTEST_UNIFORMDISTRIBUTION Test the UNIFORMDISTRIBUTION function.
%
% Example (<a href="matlab:run_example unittest_UniformDistribution">run</a>)
%   unittest_UniformDistribution
%
% See also UNIFORMDISTRIBUTION, MUNIT_RUN_TESTSUITE 

%   Elmar Zander, Aidin Nojavan
%   Copyright 2015, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'UniformDistribution' );

%%Initialization
U=UniformDistribution(2,4);
assert_equals( U.a, 2, 'Initialization a' );
assert_equals( U.b, 4, 'Initialization b' );

U=UniformDistribution(-1);
assert_equals( U.a, -1, 'Initialization default a' );
assert_equals( U.b, 1, 'Initialization default b' );

U=UniformDistribution();
assert_equals( U.a, 0, 'Initialization a' );
assert_equals( U.b, 1, 'Initialization b' );

%% Mean & Var
assert_equals(U.mean, 0.5, 'mean');
assert_equals(U.var, 0.08333333, 'var' );

%% Moments
m_act = {1, 0, 0, 0, 0};
[m_act{2:end}] = U.moments();
m_ex = compute_moments(U);
assert_equals(m_act, m_ex, 'moments' );

%% uniform_cdf
U=UniformDistribution(2,4);
assert_equals(cdf(U,1.9), 0, 'cdf_smaller' );
assert_equals(cdf(U,2.5), 1/4, 'cdf_inside' );
assert_equals(cdf(U,5), 1, 'cdf_larger' );
assert_equals(cdf(U,(U.a+U.b)/2), 1/2, 'cdf_median' );

%% uniform_pdf
U=UniformDistribution(2,4);
assert_equals( pdf(U,-inf), 0, 'pdf_minf' );
assert_equals( pdf(U,3.5), 1/2, 'pdf_inside' );
assert_equals( pdf(U,inf), 0, 'pdf_inf' );

% pdf matches cdf
x1=linspace( -0.1, 5 );
x2 = (x1(1:end-1)+x1(2:end))/2;
F=cdf( U,x1);
F2=pdf_integrate( pdf( U,x2 ), F, x1);
assert_equals( F, F2, 'pdf_cdf_match', struct('abstol',0.01) );

%% uniform_invcdf
y = linspace(0, 1);

U=UniformDistribution();
x = linspace(0, 1);
assert_equals( cdf(U,invcdf(U,y)), y, 'cdf_invcdf_1');
assert_equals( invcdf(U,cdf(U,x)), x, 'invcdf_cdf_1');
assert_equals( isnan(invcdf(U,[-0.1, 1.1])), [true, true], 'invcdf_nan1');

U=UniformDistribution(0.5);
x = linspace(0.5, 1);
assert_equals(cdf(U,invcdf(U,y)), y, 'cdf_invcdf_2');
assert_equals(invcdf(U,cdf(U,x)), x, 'invcdf_cdf_2');
assert_equals( isnan(invcdf(U,[-0.1, 1.1])), [true, true], 'invcdf_nan2');

U=UniformDistribution(-2,3);
x = linspace(-2, 3);
assert_equals(cdf(U,invcdf(U,y)), y, 'cdf_invcdf_3');
assert_equals( invcdf(U,cdf(U,x)), x, 'invcdf_cdf_3');
assert_equals( isnan(invcdf(U,[-0.1, 1.1])), [true, true], 'invcdf_nan3');

%% Sample
munit_control_rand('seed', 1234);
U=UniformDistribution(-2,3);
N=100000;
xi=U.sample(N);
assert_equals(U.cdf(sort(xi)), linspace_midpoints(0,1,N)', 'sample_cdf', 'abstol', 1e-2)

%% uniform_stdnor
N=50;
uni=linspace(0,1,N+2)';
uni=uni(2:end-1);
gam=sqrt(2)*erfinv(2*uni-1);

U=UniformDistribution(0.2,1.3);
x=stdnor(U,gam );
assert_equals(cdf(U,x), uni, 'uniform' )
U=UniformDistribution(0,1);
assert_equals(uniform_stdnor(gam), stdnor(U,gam), 'uniform_def12');
assert_equals(uniform_stdnor(gam, 0), stdnor(U,gam), 'uniform_def2');

%% translate
U=UniformDistribution(2,3);
%T=TranslatedDistribution(U,2,3);
tU=U.translate(2,3);
[m,v]=tU.moments();
%[m2,v2]=T.moments();
assert_equals( m, 4.5, 'translated mean');
assert_equals( v, 0.75, 'translated var');
assert_equals(tU.pdf(0),0,'translated pdf');
assert_equals(tU.pdf(inf),0,'translated pdf');
%T.pdf(0);
assert_equals(tU.cdf(0),0,'translated cdf','abstol',0.0001);
assert_equals(tU.cdf(inf),1,'translated cdf');
assert_equals(tU.cdf(-inf),0,'translated cdf');
assert_equals(tU.invcdf(0),3,'translated cdf');

%% fix_moments
U = UniformDistribution(22,88);
dist=fix_moments(U, 50, 3 );
[m,v]=moments(dist);
assert_equals(m, 50, 'mean fix_moments');
assert_equals(v, 3, 'uvar fix_moments');

%% Fix Bounds
U = UniformDistribution(2,3);
dist = fix_bounds(U,2,4);
assert_equals(invcdf(dist,0), 2, 'fix_bounds-uni_min');
assert_equals(invcdf(dist,1), 4, 'fix_bounds-uni_max');

%% Orthogonal polynomials
dist = UniformDistribution(-1, 1);
polysys = dist.orth_polysys();
N = 5;
assert_equals(compute_gramian(polysys, dist, N), diag(polysys.sqnorm(0:N)), 'orth');

dist = UniformDistribution(2,3);
assert_error(@()(dist.orth_polysys()), 'sglib:', 'no_standard_dist');

%% Base dist stuff
dist = UniformDistribution(2, 5);
base = dist.get_base_dist();

assert_equals(base, UniformDistribution(-1,1), 'base');

z = linspace(0,1);
x1 = dist.invcdf(z);
x2 = base.invcdf(z);
assert_equals(dist.base2dist(x2), x1, 'base2dist');
assert_equals(dist.dist2base(x1), x2, 'dist2base');


function F2=pdf_integrate( f, F, x )
F2=cumsum([F(1), f])*(x(2)-x(1));
