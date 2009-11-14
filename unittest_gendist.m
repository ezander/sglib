function unittest_gendist
% UNITTEST_GENDIST Test the GENDIST function.
%
% Example (<a href="matlab:run_example unittest_gendist">run</a>)
%   unittest_gendist
%
% See also GENDIST, TESTSUITE 

%   Elmar Zander
%   Copyright 2009, Inst. of Scientific Comuting
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

assert_set_function( 'gendist' );

% first test without shift and scaling
x=linspace(-10,10,1000);
mom_ex=cell(1,4);
mom_ac=cell(1,4);
assert_equals( gendist_pdf('beta', x, {4,2}), beta_pdf( x, 4, 2), 'beta_pdf' );
assert_equals( gendist_cdf('normal', x, {1,3}), normal_cdf( x, 1, 3), 'normal_cdf' );
assert_equals( gendist_stdnor('lognormal', x, {0,2}), lognormal_stdnor( x, 0, 2), 'lognormal_stdnor' );
[mom_ac{:}]=gendist_moments('exponential', {4});
[mom_ex{:}]=exponential_moments(4);
assert_equals( cell2mat(mom_ac), cell2mat(mom_ex), 'exponential_moments' );

% test shifting and scaling with normal distribution
assert_equals( gendist_pdf('normal', x, {0, 1}, 1.2, 3.7), normal_pdf( x, 1.2, 3.7), 'shift_normal_pdf' );
assert_equals( gendist_cdf('normal', x, {0, 1}, 1.2, 3.7), normal_cdf( x, 1.2, 3.7), 'shift_normal_cdf' );
assert_equals( gendist_stdnor('normal', x, {0, 1}, 1.2, 3.7), normal_stdnor( x, 1.2, 3.7), 'shift_normal_stdnor' );
[mom_ac{:}]=gendist_moments('normal', {0, 1}, 1.2, 3.7);
[mom_ex{:}]=normal_moments(1.2, 3.7);
assert_equals( cell2mat(mom_ac), cell2mat(mom_ex), 'shift_normal_moments' );

% second test shifting and scaling 
assert_equals( gendist_pdf('normal', x, {1, 2}, 2.5, 3), normal_pdf( x, 3.5, 6), 'shift_normal_pdf2' );
assert_equals( gendist_cdf('normal', x, {1, 2}, 2.5, 3), normal_cdf( x, 3.5, 6), 'shift_normal_cdf2' );
assert_equals( gendist_stdnor('normal', x, {1, 2}, 2.5, 3), normal_stdnor( x, 3.5, 6), 'shift_normal_stdnor2' );
[mom_ac{:}]=gendist_moments('normal', {1, 2}, 2.5, 3);
[mom_ex{:}]=normal_moments(3.5, 6);
assert_equals( cell2mat(mom_ac), cell2mat(mom_ex), 'shift_normal_moments2' );

% test internal consistency of shifting and scaling with beta distribution
x=linspace(-10,10,10000);
h=x(2)-x(1);
mom_ex=cell(1,4);
mom_ac=cell(1,4);
pdf=gendist_pdf('beta', x, {2.5, 3.7}, 1.3, 4.6);
cdf=gendist_cdf('beta', x, {2.5, 3.7}, 1.3, 4.6);
% -> test that pdf is the derivative of cdf
assert_equals( sum((diff(cdf)-h*0.5*(pdf(2:end)+pdf(1,end-1))).^2), 0, 'l2_pdf_cdf', 'abstol', 2e-4 );

% test moments by integration of x^n over pdf
[mean,var,skew,kurt]=gendist_moments('beta', {2.5, 3.7}, 1.3, 4.6);
mean_pdf=sum(h*x.*pdf);
assert_equals( mean, mean_pdf, 'mean_pdf');
var_pdf=sum(h*(x-mean).^2.*pdf);
assert_equals( var, var_pdf, 'var_pdf');
skew_pdf=sum(h*((x-mean)/sqrt(var)).^3.*pdf);
assert_equals( skew, skew_pdf, 'skew_pdf', 'abstol', 1e-6 );
kurt_pdf=sum(h*((x-mean)/sqrt(var)).^4.*pdf)-3;
assert_equals( kurt, kurt_pdf, 'kurt_pdf', 'abstol', 1e-6 );

% test that cdf(stdnor()) is cdf of normal dist
x=linspace(-7,7,1000);
stdnor=gendist_stdnor('beta', x, {2.5, 3.7}, 1.3, 4.6);
y=gendist_cdf('beta', stdnor, {2.5, 3.7}, 1.3, 4.6);
assert_equals( y, normal_cdf(x), 'cdf_stdnor_normal' );
