function test_distributions
% TEST_DISTRIBUTIONS Test the distribution functions.
%
% Example 
%    test_distributions
%
% See also TESTSUITE

%   Elmar Zander
%   Copyright 2007, Institute of Scientific Computing, TU Braunschweig.
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.



assert_set_function( 'distributions' );

%% Normal distribution
assert_set_function('distributions/normal');
mu=1; sig=2;
assert_equals( normal_cdf(-inf,mu,sig), 0, 'cdf_minf' );
assert_equals( normal_cdf(inf,mu,sig), 1, 'cdf_inf' );
assert_equals( normal_cdf(mu,mu,sig), 1/2, 'cdf_median' );

assert_equals( normal_pdf(-inf,mu,sig), 0, 'pdf_minf' );
assert_equals( normal_pdf(inf,mu,sig), 0, 'pdf_inf' );

[x1,x2]=linspace_mp(mu-5*sig,mu+5*sig);
F=normal_cdf(x1, mu, sig);
F2=pdf_integrate( normal_pdf(x2,mu,sig), F, x1);
assert_equals( F, F2, 'pdf_cdf_match', struct('abstol',0.01) );

%% Lognormal distribution
assert_set_function('distributions/lognorm');
mu=2; sig=0.5;
assert_equals( lognorm_cdf(-inf,mu,sig), 0, 'cdf_minf' );
assert_equals( lognorm_cdf(-1e8,mu,sig), 0, 'cdf_negative' );
assert_equals( lognorm_cdf(inf,mu,sig), 1, 'cdf_inf' );
assert_equals( lognorm_cdf(exp(mu),mu,sig), 1/2, 'cdf_median' );

assert_equals( lognorm_pdf(-inf,mu,sig), 0, 'pdf_minf' );
assert_equals( lognorm_pdf(-1e8,mu,sig), 0, 'pdf_negative' );
assert_equals( lognorm_pdf(inf,mu,sig), 0, 'pdf_inf' );

[x1,x2]=linspace_mp(0,exp(mu+5*sig));
F=lognorm_cdf(x1, mu, sig);
F2=pdf_integrate( lognorm_pdf(x2,mu,sig), F, x1);
assert_equals( F, F2, 'pdf_cdf_match', struct('abstol',0.01) );

%% Exponential distribution
assert_set_function('distributions/exponential');
alpha=1.5;
assert_equals( exponential_cdf(-inf,alpha), 0, 'cdf_minf' );
assert_equals( exponential_cdf(-1e10,alpha), 0, 'cdf_negative' );
assert_equals( exponential_cdf(inf,alpha), 1, 'cdf_inf' );
assert_equals( exponential_cdf(log(2)/alpha,alpha), 1/2, 'cdf_median' );

assert_equals( exponential_pdf(-inf,alpha), 0, 'pdf_minf' );
assert_equals( exponential_pdf(-1e10,alpha), 0, 'pdf_negative' );
assert_equals( exponential_pdf(inf,alpha), 0, 'pdf_inf' );

[x1,x2]=linspace_mp( -0.1, 5 );
F=exponential_cdf( x1, alpha );
F2=pdf_integrate( exponential_pdf( x2, alpha ), F, x1);
assert_equals( F, F2, 'pdf_cdf_match', struct('abstol',0.01) );

%% Beta distribution
assert_set_function('distributions/beta');
a=2; b=3;
assert_equals( beta_cdf(-inf,a,b), 0, 'cdf_minf' );
assert_equals( beta_cdf(-1e8,a,b), 0, 'cdf_zero' );
assert_equals( beta_cdf(1+1e8,a,b), 1, 'cdf_zero' );
assert_equals( beta_cdf(inf,a,b), 1, 'cdf_inf' );
assert_equals( beta_cdf(1/2,a,a), 1/2, 'cdf_median' );
assert_equals( beta_cdf(1/2,b,b), 1/2, 'cdf_median' );
assert_equals( beta_cdf(1/2,1/b,1/b), 1/2, 'cdf_median' );

assert_equals( beta_pdf(-inf,a,b), 0, 'pdf_minf' );
assert_equals( beta_pdf(-1e8,a,b), 0, 'pdf_zero' );
assert_equals( beta_pdf(0,a,b), 0, 'pdf_zero' );
assert_equals( beta_pdf(1,a,b), 0, 'pdf_zero' );
assert_equals( beta_pdf(1+1e8,a,b), 0, 'pdf_zero' );
assert_equals( beta_pdf(inf,a,b), 0, 'pdf_inf' );

a=0.2;b=0.5;
assert_equals( beta_pdf(0,a,b), 0, 'pdf_zero' );
assert_equals( beta_pdf(1,a,b), 0, 'pdf_zero' );

a=2; b=3;
[x1,x2]=linspace_mp(-0.1,1.1);
F=beta_cdf(x1,a,b);
F2=pdf_integrate( beta_pdf(x2,a,b), F, x1);
assert_equals( F, F2, 'pdf_cdf_match', struct('abstol',0.01) );

function [x1,x2]=linspace_mp( xmin, xmax )
x1=linspace(xmin,xmax,100);
x2=x1(1:end-1)+(x1(2)-x1(1))/2;

function F2=pdf_integrate( f, F, x )
F2=cumsum([F(1), f])*(x(2)-x(1));
