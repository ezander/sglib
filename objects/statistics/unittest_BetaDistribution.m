function unittest_BetaDistribution
% UNITTEST_BETADISTRIBUTION Test the BETADISTRIBUTION function.
%
%   Aidin Nojavan
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
%%Initialization
B = BetaDistribution(2,3);
assert_equals( B.a, 2, 'Initialization a' );
assert_equals( B.b, 3, 'Initialization b' );

%% beta_cdf
assert_equals(cdf(B,-inf),0, 'cdf_minf' );
assert_equals(cdf(B,-1e8), 0, 'cdf_zero' );
assert_equals( cdf(B, 1+1e8), 1, 'cdf_zero' );
assert_equals( cdf(B,inf), 1, 'cdf_inf' );
B = BetaDistribution(2,2);
assert_equals(cdf(B,1/2), 1/2, 'cdf_median' );
B = BetaDistribution(3,3);
assert_equals(cdf(B,1/2), 1/2, 'cdf_median' );
B = BetaDistribution(1/3,1/3);
assert_equals(cdf(B,1/2), 1/2, 'cdf_median' );


%% beta_pdf
B = BetaDistribution(2,3);
assert_equals( pdf(B,-inf), 0, 'pdf_minf' );
assert_equals( pdf(B,-1e8), 0, 'pdf_zero' );
assert_equals( pdf(B,0), 0, 'pdf_zero' );
assert_equals( pdf(B,1), 0, 'pdf_zero' );
assert_equals( pdf(B,1+1e8), 0, 'pdf_zero' );
assert_equals( pdf(B,inf), 0, 'pdf_inf' );

B = BetaDistribution(0.2,0.5);
assert_equals(pdf(B,0), 0, 'pdf_zero' );
assert_equals(pdf(B,1), 0, 'pdf_zero' );

% % pdf matches cdf
% B = BetaDistribution(2,3);
% [x,x2]=linspace_mp(-0.1,1.1);
% F=beta_cdf(x,a,b);
% F2=pdf_integrate( beta_pdf(x2,a,b), F, x);
% assert_equals( F, F2, 'pdf_cdf_match', struct('abstol',0.01) );


%% beta_invcdf

y = linspace(0, 1);
x = linspace(0, 1);

B = BetaDistribution(2,3);
assert_equals( cdf(B,invcdf(B,y)), y, 'cdf_invcdf_1');
assert_equals( invcdf(B,cdf(B,x)), x, 'invcdf_cdf_1');
assert_equals( isnan(invcdf(B,[-0.1, 1.1])), [true, true], 'invcdf_nan1');

B = BetaDistribution(0.5,0.5);
assert_equals( cdf(B,invcdf(B,y)), y, 'cdf_invcdf_2');
assert_equals(invcdf(B,cdf(B,x)), x, 'invcdf_cdf_2');
assert_equals( isnan(invcdf(B,[-0.1, 1.1])), [true, true], 'invcdf_nan2');

B = BetaDistribution(1,1);
assert_equals( cdf(B,invcdf(B,y)), y, 'cdf_invcdf_3');
assert_equals( invcdf(B,cdf(B,x)), x, 'invcdf_cdf_3');
assert_equals( isnan(invcdf(B,[-0.1, 1.1])), [true, true], 'invcdf_nan3');

%% beta_stdnor

N=50;
uni=linspace(0,1,N+2)';
uni=uni(2:end-1);
gam=sqrt(2)*erfinv(2*uni-1);
x=beta_stdnor(gam, 0.5, 1.3);

B = BetaDistribution(0.5,1.3);
assert_equals( cdf(B,x), uni, 'beta' );


