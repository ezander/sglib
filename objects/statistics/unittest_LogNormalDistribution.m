function unittest_LogNormalDistribution
% UNITTEST_LOGNORMALDISTRIBUTION Test the LOGNORMALDISTRIBUTION function.
%
% Example (<a href="matlab:run_example unittest_LogNormalDistribution">run</a>)
%   unittest_LogNormalDistribution
%
% See also LOGNORMALDISTRIBUTION, MUNIT_RUN_TESTSUITE 

%   Aidin Nojavan
%   Copyright 2014, <Inst. of Scientific Computing, TU Braunschweig>
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'LogNormalDistribution' );

%% Initialization
LN=LogNormalDistribution(2,3);
assert_equals( LN.mu, 2, 'Initialization default a' );
assert_equals( LN.sigma,3, 'Initialization default b' );

LN=LogNormalDistribution(2);
assert_equals( LN.mu, 2, 'Initialization default a' );
assert_equals( LN.sigma, 1, 'Initialization default b' );

LN=LogNormalDistribution();
assert_equals( LN.mu, 0, 'Initialization default a' );
assert_equals( LN.sigma, 1, 'Initialization default b' );

%% Mean & Var
assert_equals(LN.mean, exp(1/2), 'mean');
assert_equals(LN.var, exp(2)-exp(1), 'var' );
%% lognormal_cdf
LN=LogNormalDistribution(2,0.5);
assert_equals(cdf(LN,-inf), 0, 'cdf_minf' );
assert_equals(cdf(LN,-1e8), 0, 'cdf_negative' );
assert_equals(cdf(LN,inf), 1, 'cdf_inf' );
assert_equals(cdf(LN,exp(LN.mu)), 1/2, 'cdf_median' );

% lognormal_pdf
assert_equals(pdf(LN,-inf), 0, 'pdf_minf' );
assert_equals(pdf(LN,-1e8), 0, 'pdf_negative' );
assert_equals(pdf(LN,inf), 0, 'pdf_inf' );

% lognormal_invcdf
y = linspace(0, 1);
x = linspace(0, 10);

LN=LogNormalDistribution();
assert_equals(cdf(LN,invcdf(LN,y)), y, 'cdf_invcdf_1');
assert_equals(invcdf(LN,cdf(LN,x)), x, 'invcdf_cdf_1');
assert_equals( isnan(invcdf(LN,[-0.1, 1.1])), [true, true], 'invcdf_nan1');

LN=LogNormalDistribution(0,0.5);
assert_equals(cdf(LN,invcdf(LN,y)), y, 'cdf_invcdf_2');
assert_equals(invcdf(LN,cdf(LN,x)), x, 'invcdf_cdf_2');
assert_equals( isnan(invcdf(LN,[-0.1, 1.1])), [true, true], 'invcdf_nan2');

LN=LogNormalDistribution(0.7,1.5);
assert_equals(cdf(LN,invcdf(LN,y)),cdf(LN,invcdf(LN,y)),'cdf_invcdf_3');
assert_equals(invcdf(LN,cdf(LN,x)), x, 'invcdf_cdf_3');
assert_equals( isnan(invcdf(LN,[-0.1, 1.1])), [true, true], 'invcdf_nan3');

% % lognormal_stdnor
N=50;
uni=linspace(0,1,N+2)';
uni=uni(2:end-1);
gam=sqrt(2)*erfinv(2*uni-1);

LN=LogNormalDistribution(0.2,0.3);
x=stdnor( LN,gam );
assert_equals(cdf(LN,x), uni, 'lognormal' )
assert_equals( lognormal_stdnor(gam), lognormal_stdnor(gam, 0, 1), 'lognormal_def12');
assert_equals( lognormal_stdnor(gam, 0), lognormal_stdnor(gam, 0, 1), 'lognormal_def2');
%% fix_moments
LN=LogNormalDistribution(2,3);
dist=fix_moments(LN,4,14);
[m,v]=moments(dist);
assert_equals(m,4,'mean fix_moments');
assert_equals(v,14,'var fix_moments');

%% Fix Bounds
LN = LogNormalDistribution(2,3);
dist = fix_bounds(LN,2,4,'q0',0.001,'q1', 0.5);
assert_equals(invcdf(dist,0.001), 2, 'fix_bounds-nor_min');
assert_equals(invcdf(dist,0.5), 4, 'fix_bounds-nor_max');