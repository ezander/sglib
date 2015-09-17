function r_i_alpha = kl_to_pce(mu_r_i, r_i_k, sigma_k, r_k_alpha, I_r)
% KL_TO_PCE Transform KL representation into a PCE representation.
%   R_I_ALPHA = KL_TO_PCE(MU_R_I, R_I_K, SIGMA_K, R_K_ALPHA, I_R)
%   transforms the KL representation, given by the mean MU_R_I, the spatial
%   KL eigenfunctions R_I_K, the KL eigenvalues SIGMA_K, and the random
%   variables R_K_ALPHA (in PCE representation w.r.t to the multiindex set
%   I_R) into a PCE representation R_I_ALPHA. 
%   
%   R_I_ALPHA = KL_TO_PCE([], R_I_K, SIGMA_K, R_K_ALPHA) does the same,
%   assuming the mean is zero.
%
%   R_I_ALPHA = KL_TO_PCE(MU_R_I, R_I_K, [], R_K_ALPHA, I_R) does the same,
%   assuming the SIGMA_K are constant 1 (i.e. they are already part of the
%   R_I_K or the R_K_ALPHA.)
%
%   R_I_ALPHA = KL_TO_PCE([], R_I_K, [], R_K_ALPHA) or R_I_ALPHA =
%   KL_TO_PCE(R_I_K, R_K_ALPHA) assumes the mean is zero and the KL
%   eigenvalues are all one.
%
% Note: if the mean is specified I_R has to be be passed to the function in
%   order to determine where the mean component of the PCE is.
%
% Example (<a href="matlab:run_example kl_to_pce">run</a>)
%   
% See also PCE_TO_KL

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

if nargin==2
    % using old version of the function
    [r_i_alpha] = kl_to_pce([], mu_r_i, [], r_i_k);
    return;
end

if isempty(sigma_k)
    r_i_alpha = r_i_k * r_k_alpha;
else
    r_i_alpha = binfun(@times, r_i_k, sigma_k(:)') * r_k_alpha;
end

if ~isempty(mu_r_i)
    m = size(I_r, 2);
    mean_ind = multiindex_find(multiindex(m,0), I_r);
    assert(length(mean_ind)==1);
    r_i_alpha(:,mean_ind) = r_i_alpha(:,mean_ind) + mu_r_i;
end
