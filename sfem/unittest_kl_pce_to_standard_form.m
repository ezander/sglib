function unittest_kl_pce_to_standard_form
% UNITTEST_KL_PCE_TO_STANDARD_FORM Test the KL_PCE_TO_STANDARD_FORM function.
%
% Example (<a href="matlab:run_example unittest_kl_pce_to_standard_form">run</a>)
%   unittest_kl_pce_to_standard_form
%
% See also KL_PCE_TO_STANDARD_FORM, MUNIT_RUN_TESTSUITE 

%   Elmar Zander
%   Copyright 2010, Inst. of Scientific Computing
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'kl_pce_to_standard_form' );

N=51;
M=56;
L=15;

rc_i_k=rand(N,L);
rc_k_alpha=rand(L,M);

[mu_rs_i,rs_i_k,sigma_rs_k,rs_k_alpha]=kl_pce_to_standard_form(rc_i_k,rc_k_alpha);

r_i_alpha_ex=rc_i_k*rc_k_alpha;
r_i_alpha_ac=rs_i_k*diag(sigma_rs_k)*rs_k_alpha;
r_i_alpha_ac(:,1)=r_i_alpha_ac(:,1)+mu_rs_i;
assert_equals(r_i_alpha_ac, r_i_alpha_ex, 'same_pce');


% check consistency with reverse method
[rc_i_k2,rc_k_alpha2]=kl_pce_to_compact_form(mu_rs_i,rs_i_k,sigma_rs_k,rs_k_alpha);
[mu_rs_i2,rs_i_k2,sigma_rs_k2,rs_k_alpha2]=kl_pce_to_standard_form(rc_i_k2,rc_k_alpha2);

assert_equals(mu_rs_i, mu_rs_i2, 'same_mu');
assert_equals(sigma_rs_k2, sigma_rs_k, 'same_sig');
