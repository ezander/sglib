function [rc_i_k,rc_k_alpha]=kl_pce_to_compact_form(mu_rs_i,rs_i_k,sigma_rs_k,rs_k_alpha)
% KL_PCE_TO_COMPACT_FORM Short description of kl_pce_to_compact_form.
%   KL_PCE_TO_COMPACT_FORM Long description of kl_pce_to_compact_form.
%
% Example (<a href="matlab:run_example kl_pce_to_compact_form">run</a>)
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

% scale the spatial eigenfunctions by sigma_k
if isempty(sigma_rs_k)
    rc_i_k=rs_i_k;
else
    rc_i_k=rs_i_k*diag(sigma_rs_k);
end

if ~isempty(mu_rs_i)
    % insert deteminstic vector as zeroth eigenfunction
    rc_i_k=[mu_rs_i, rc_i_k];
    
    %
    M=size(rs_k_alpha,2);
    rc_k_alpha=[1, zeros(1,M-1); rs_k_alpha];
else
    rc_k_alpha=rs_k_alpha;
end
