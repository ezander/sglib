function [mu_rs_i,rs_i_k,sigma_rs_k,rs_k_alpha]=kl_pce_to_standard_form(rc_i_k,rc_k_alpha,I_rc)
% KL_PCE_TO_STANDARD_FORM Short description of kl_pce_to_standard_form.
%   KL_PCE_TO_STANDARD_FORM Long description of kl_pce_to_standard_form.
%
% Example (<a href="matlab:run_example kl_pce_to_standard_form">run</a>)
%
% See also

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

N=size(rc_i_k,1);
M=size(rc_k_alpha,2);
L=size(rc_i_k,2);
G_N=speye(N);
if nargin<3
    G_X=speye(M);
else
    G_X=spdiags(multiindex_factorial(I_rc), 0, M, M);
end

% extract mean into mu_rs_i and remove from pce variable
mu_rs_i=rc_i_k*rc_k_alpha(:,1);
rc_k_alpha(:,1)=0;

% orthogonalize eigenfunctions and extract sigma
[rs_i_k, rs_k_alpha, sigma_rs_k]=orthogonalize( rc_i_k, rc_k_alpha', G_N, G_X );
rs_k_alpha=rs_k_alpha';


function [U1,U2,sigma]=orthogonalize(T1,T2,G1,G2)
% check that no vector is zero (the really thing to remove linearly
% dependent vectors later in gram-schmidt, however due to the construction
% of the KL compact form special case handled here happens quite often and
% thus deserves special treatment.
ind=(sum(abs(T1),1)~=0)&(sum(abs(T2),1)~=0);
T1=T1(:,ind);
T2=T2(:,ind);

[Q1,R1]=qr_internal(T1,G1,0);
[Q2,R2]=qr_internal(T2,G2,0);
[V1,S,V2]=svd(R1*R2',0);
sigma=diag(S);
U1=Q1*V1;
U2=Q2*V2;
