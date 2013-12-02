function [r_i_k,r_k_alpha]=project_pce_on_kl( r_i_alpha, I_r, v_i_k )
% PROJECT_PCE_ON_KL Project a spatially PC expanded field into a KL-PCE field.
%   [R_I_K,R_K_ALPHA]=PROJECT_PCE_ON_KL( R_I_ALPHA, I_R, V_I_K ) transforms
%   a field that is given by a pointwise PCE into a field given by a KL
%   with PCE for each KL random variable.
%
% Example (<a href="matlab:run_example project_pce_on_kl">run</a>)
%
% See also

%   Elmar Zander
%   Copyright 2010, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

if size(v_i_k,1)~=size(r_i_alpha,1)
    error( 'project_pce_on_kl:wrong_args', 'Input arguments r_i_alpha and r_i_k must have the same spatial dimension (2)' );
end

% Extract the mean of the KL expansion (that's simply the coefficient in
% the PCE corresponding to the multiindex [0,0,0,...] )
mu_rs_i=r_i_alpha(:,1);
r_i_alpha(:,1)=0;

% Normalize the v_i_k (what they should be already, just in case)
sigma_k=sqrt(sum( v_i_k.^2, 1 ));
rs_i_k=row_col_mult( v_i_k, 1./sigma_k );

% Now do the projection. Since the v_i_k are normalized this amounts to just a
% scalar product between the PCE coefficients and the v_i_k's.
rs_k_alpha=rs_i_k'*r_i_alpha;

[r_i_k, r_k_alpha]=kl_pce_to_compact_form( mu_rs_i, rs_i_k, [], rs_k_alpha );
