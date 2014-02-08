function unittest_pce_expand_1d
% UNITTEST_PCE_EXPAND_1D Test the univariate PCE expansion
%
% Example (<a href="matlab:run_example unittest_pce_expand_1d">run</a>)
%    unittest_pce_expand_1d
%
% See also PCE_EXPAND_1D, MUNIT_RUN_TESTSUITE

%   Elmar Zander
%   Copyright 2007, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


munit_set_function( 'pce_expand_1d' );

%% Check that the normal distribution is approximated correctly
mu=3; sigma=5;
N_h={@normal_stdnor, {mu,sigma}, {2,3}};
[N_alpha,I_N]=pce_expand_1d(N_h,7);
% only the coefficient for H_1 should be 1, the rest zero
assert_equals( N_alpha, [mu,sigma,0,0,0,0,0,0], 'normal_coeffs' );
assert_equals( I_N, (0:7)', 'normal_multindex' );

%% Check that polynomials are approximated correctly
H=hermite(10,true);
for p=0:5
    M_h={@power,{p},{2}};
    M_alpha=pce_expand_1d(M_h,10);
    % only the coefficient for x should be 1, the rest zero
    P_act=M_alpha*H;
    P_ex=double((1:11)==(11-p));
    assert_equals( P_act, P_ex, sprintf('poly_coeffs_%d', p) );
end

%% lognormal mean and variance
mu=2;
sigma=1;
p=12;
L_h={@lognormal_stdnor,{mu,sigma},{2,3}};
L_alpha=pce_expand_1d(L_h,p);

L_mu=exp(mu+sigma^2/2);
L_mu_pce = L_alpha(1);
assert_equals( L_mu_pce, L_mu, 'mean' );

L_var=(exp(sigma^2)-1)*exp(2*mu+sigma^2);
L_var_pce = sum(L_alpha(2:end).^2.*factorial(1:p));
assert_equals( L_var_pce, L_var, 'variance' );

%% Approximate the exponential distribution
lambda=3;
p=12;
Exp_h={@exponential_stdnor,{lambda},{2}};
Exp_alpha=pce_expand_1d(Exp_h,p);
[mu_pce, var_pce]=pce_moments( Exp_alpha, [] );
[mu_ex, var_ex]=exponential_moments( lambda );
assert_equals( mu_pce, mu_ex, 'exp_mean' );
assert_equals( var_pce, var_ex, 'exp_variance' );


%% Lognormal distribution: 
Log_h={@lognormal_stdnor,{3,0.5},{2,3}};
Log_alpha=pce_expand_1d(Log_h,5);

Log_alpha_ex=exp(3.125)./factorial(0:5).*(0.5.^(0:5)); 
assert_equals( Log_alpha, Log_alpha_ex, 'lognormal' );

