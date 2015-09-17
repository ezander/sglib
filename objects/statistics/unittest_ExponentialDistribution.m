function unittest_ExponentialDistribution
% UNITTEST_EXPONENTIALDISTRIBUTION Test the EXPONENTIALDISTRIBUTION function.
%
% Example (<a href="matlab:run_example unittest_ExponentialDistribution">run</a>)
%   unittest_ExponentialDistribution
%
% See also EXPONENTIALDISTRIBUTION, MUNIT_RUN_TESTSUITE

%   <Aidin Nojavan>
%   Copyright 2014, <Inst. of Scientific Computing, TU Braunschweig>
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'ExponentialDistribution' );
%% Mean & Var
E = ExponentialDistribution(1.5);
assert_equals(E.mean, 0.6666666, 'mean','abstol',0.0001 );
assert_equals(E.var, 0.44444444, 'var' );
%% exponential_cdf
assert_equals(cdf(E,-inf), 0, 'cdf_minf' );
assert_equals(cdf(E,-1e10), 0, 'cdf_negative' );
assert_equals(cdf(E,inf), 1, 'cdf_inf' );
assert_equals(cdf(E,log(2)/E.lambda), 1/2, 'cdf_median' );


%% exponential_pdf
assert_equals(pdf(E,-inf), 0, 'pdf_minf' );
assert_equals(pdf(E,-1e10), 0, 'pdf_negative' );
assert_equals(pdf(E,inf), 0, 'pdf_inf' );

%% exponential_invcdf
y = linspace(0, 1);
E = ExponentialDistribution(2);
assert_equals(cdf(E,invcdf(E,y)), y, 'cdf_invcdf_1');
assert_equals(invcdf(E,cdf(E,y)), y, 'invcdf_cdf_1');
assert_equals( isnan(invcdf(E,[-0.1, 1.1])), [true, true], 'invcdf_nan1');

E = ExponentialDistribution(0.5);
assert_equals(cdf(E,invcdf(E,y)), y, 'cdf_invcdf_1');
assert_equals(invcdf(E,cdf(E,y)), y, 'invcdf_cdf_1');
assert_equals( isnan(invcdf(E,[-0.1, 1.1])), [true, true], 'invcdf_nan1');


%% exponential_stdnor
N=50;
uni=linspace(0,1,N+2)';
uni=uni(2:end-1);
gam=sqrt(2)*erfinv(2*uni-1);

E = ExponentialDistribution(0.7);
x=stdnor( E,gam );
assert_equals(cdf(E,x), uni, 'exponential' )

%% fix_moments
E=ExponentialDistribution(4);
dist=fix_moments(E,5,7);
[m,v]=moments(dist);
assert_equals(m,5,'mean fix_moments');
assert_equals(v,7,'var fix_moments');
%% Fix Bounds
E = ExponentialDistribution(4);
dist = fix_bounds(E,2,4,'q0',0.001,'q1', 0.5);
assert_equals(invcdf(dist,0.001), 2, 'fix_bounds-nor_min');
assert_equals(invcdf(dist,0.5), 4, 'fix_bounds-nor_max');