function unittest_kl_pce_to_compact_form
% UNITTEST_KL_PCE_TO_COMPACT_FORM Test the KL_PCE_TO_COMPACT_FORM function.
%
% Example (<a href="matlab:run_example unittest_kl_pce_to_compact_form">run</a>)
%   unittest_kl_pce_to_compact_form
%
% See also KL_PCE_TO_COMPACT_FORM, MUNIT_RUN_TESTSUITE 

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

munit_set_function( 'kl_pce_to_compact_form' );

N=51;
M=56;
L=15;

mu_rs_i=rand(N,1);
rs_i_k=rand(N,L);
rs_k_alpha=[zeros(L,1), rand(L,M-1)];
sigma_r=1./(1:L);

[rc_i_k,rc_k_alpha]=kl_pce_to_compact_form(mu_rs_i,rs_i_k,[],rs_k_alpha);
r_i_alpha_ex=rs_i_k*rs_k_alpha;
r_i_alpha_ex(:,1)=r_i_alpha_ex(:,1)+mu_rs_i;
r_i_alpha_ac=rc_i_k*rc_k_alpha;
assert_equals(r_i_alpha_ac, r_i_alpha_ex, 'pce_nosig');

[rc_i_k,rc_k_alpha]=kl_pce_to_compact_form(mu_rs_i,rs_i_k,sigma_r,rs_k_alpha);
r_i_alpha_ex=rs_i_k*diag(sigma_r)*rs_k_alpha;
r_i_alpha_ex(:,1)=r_i_alpha_ex(:,1)+mu_rs_i;
r_i_alpha_ac=rc_i_k*rc_k_alpha;
assert_equals(r_i_alpha_ac, r_i_alpha_ex, 'pce_sigma');


