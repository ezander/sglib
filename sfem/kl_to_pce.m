function [r_i_alpha] = kl_to_pce(mu_r_k, r_i_k, sigma_k, r_k_alpha, I_r)
% KL_TO_PCE Short description of kl_to_pce.
%   KL_TO_PCE Long description of kl_to_pce.
%
% Example (<a href="matlab:run_example kl_to_pce">run</a>)
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

if nargin==2
    % using old version of the function
    [r_i_alpha] = kl_to_pce([], mu_r_k, [], r_i_k);
    return;
end

if isempty(sigma_k)
    r_i_alpha = r_i_k * r_k_alpha;
else
    r_i_alpha = binfun(@times, r_i_k, sigma_k) * r_k_alpha;
end

if ~isempty(mu_r_k)
    m = size(I_g, 2);
    mean_ind = multiindex_find(multiindex(m,0));
    assert(length(mean_ind)==1);
    r_i_alpha(:,mean_ind) = r_i_alpha(:,mean_ind) + mu_r_k;
end
