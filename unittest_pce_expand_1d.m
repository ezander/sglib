function unittest_pce_expand_1d
% UNITTEST_PCE_EXPAND_1D Test the univariate PCE expansion 
%
% Example (<a href="matlab:run_example unittest_pce_expand_1d">run</a>) 
%    unittest_pce_expand_1d
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


assert_set_function( 'pce_expand' );

%% Check that the normal distribution is approximated correctly
[pcc,pci,poc]=pce_expand_1d(@(x)(x),7);
% only the coefficient for H_1 should be 1, the rest zero
assert_equals( pcc, [0,1,0,0,0,0,0,0], 'hermite_coeffs' );
assert_equals( pci, (0:7)', 'hermite_index' );
% only the coefficient for x should be 1, the rest zero
assert_equals( poc, [0,0,0,0,0,0,1,0], 'poly_coeffs' );


%% Check that polynomials are approximated correctly
for p=0:5 
    f={@power,{p},{2}};
    [pcc,pci,poc]=pce_expand_1d(f,10); 
    pcc; pci; %#ok pcc, pci unused
    % only the coefficient for x should be 1, the rest zero
    poc_ex=zeros(1,11);
    poc_ex(end-p)=1;
    assert_equals( poc, poc_ex, 'poly_coeffs' );
end

%% lognormal mean and variance
mu=2;
sigma=1;
p=8;
%h=@(x)(lognormal_stdnor(x,mu,sigma));
h={@lognormal_stdnor,{mu,sigma},{2,3}};
%h=inline( sprintf( 'lognormal_stdnor(x,%0.16e,%0.16e)', mu,sigma ), 'x' );
pcc=pce_expand_1d(h,p);

ln_mean=exp(mu+sigma^2/2);
ln_mean_pce = pcc(1);
assert_equals( ln_mean_pce, ln_mean, 'mean' );

ln_var=(exp(sigma^2)-1)*exp(2*mu+sigma^2);
ln_var_pce = sum(pcc(2:end).^2.*factorial(1:p));
assert_equals( ln_var_pce, ln_var, 'variance', struct( 'reltol', 1e-5 ) );

%% Approximate the exponential distribution
lambda=3;
p=7;
%h=inline( sprintf( 'exponential_stdnor(x,%0.16e)', lambda ), 'x' );
h={@exponential_stdnor,{lambda},{2}};
pcc=pce_expand_1d(h,p);
[mu_pce, var_pce]=pce_moments( pcc );
[mu_ex, var_ex]=exponential_moments( lambda );
assert_equals( mu_pce, mu_ex, 'exp_mean' );
assert_equals( var_pce, var_ex, 'exp_variance', struct('reltol', 1e-6) );


%% Lognormal distribution: comparison between analytical and MC solution
N=10000;
h={@lognormal_stdnor,{3,0.5},{2,3}};
lognor_data=funcall(h,randn(N*10,1));
pcc_int=pce_expand_1d(h,5);
%pcc_mc=pce_expand_1d_mc(h,5);
pcc_mc2=pce_expand_1d_mc(lognor_data,5);


pcc_ex=exp(3.125)./factorial(0:5).*(0.5.^(0:5)); % =exp(mu+sig^2/2)*(1+sig*gamma/1!+sig^2*gamma^2/2!+...)
mc_options.abstol=1e-2;
mc_options.reltol=10/sqrt(N);
mc_options.fuzzy=true;
assert_equals( pcc_int, pcc_ex, 'numint' );
%assert_equals( pcc_mc, pcc_ex, 'mc', mc_options );
assert_equals( pcc_mc2(1:3), pcc_ex(1:3), 'mc_data', mc_options );

