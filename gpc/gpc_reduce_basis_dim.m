function [u_i_beta, V_un] = gpc_reduce_basis_dim(u_i_alpha, V_u,  dim_index, varargin)
% GPC_REDUCE_BASIS_DIM reduces the dimensions of a GPC basis.
%   GPC_REDUCE_BASIS_DIM reduces the dimensions of the gpcbasis for the
%   dimension specified in DIM_INDEX and calculates the new reduced basis
%   and the modified coefficients U_I_BETA, by multiplying the original
%   coefficients with the polynomial values at the fixed germs.
%
%   [u_i_beta, V_u_red] =GPC_REDUCE_BASIS_DIM(u_i_alpha, V_u, [1,2])
%   where DIM_INDEX=[1,2] means that dependence on only first and second
%   RV/germ will be kept.
%
% The function is usefull when dependence on only few terms are to be
% analysed, or when a response surface is to be plotted for gpc basis with
% more then two random variables (or rather germs). The function fixes the
% germs (which are not indexed in DIM_INDEX) at their mean
% values. These germs can be also fixed at certain quantiles as well (see
% optional input FIXED_VALUE)
%
% Options:
%   fixed_value: 'mean', 'quantile'
%      Determine how the uniform samples are generated. In the default mode
%      some samples (e.g. for normal rv's) are generated directly and not
%      via the inverse cdf transform method.
%
% Example 1 (<a href="matlab:run_example  gpc_reduce_basis_dim 1">run</a>)
%   a1_dist=gendist_create('beta', {1.2, 2});
%   a1_dist=gendist_fix_bounds(a1_dist, 0.5, 5);
%   a2_dist=gendist_create('beta', {0.6, 0.3});
%   a2_dist=gendist_fix_bounds(a2_dist, 50, 150);
%   a3_dist=gendist_create('beta', {1.2, 2});
%   a3_dist=gendist_fix_bounds(a3_dist, 5, 10);
%
%   [a1_alpha, V1]=gpc_param_expand(a1_dist, 'u');
%   [a2_alpha, V2]=gpc_param_expand(a2_dist, 't');
%   [a3_alpha, V3]=gpc_param_expand(a3_dist, 't');
%
%   [ai_alpha12, V12]=gpc_combine_inputs(a1_alpha, V1, a2_alpha, V2);
%   [ai_alpha123, V123]=gpc_combine_inputs(ai_alpha12, V12, a3_alpha, V3);
%
%   [u_i_beta, V_u_red] = gpc_reduce_basis_dim(ai_alpha123, V123,  [1,2]);
%   subplot(2,2,1)
%   plot_response_surface(ai_alpha12(1,:), V12 )
%   subplot(2,2,2)
%   plot_response_surface(ai_alpha12(2,:), V12 )
%   subplot(2,2,3)
%   plot_response_surface(u_i_beta(1,:), V_u_red)
%   subplot(2,2,4)
%   plot_response_surface(u_i_beta(2,:), V_u_red)
% See also PLOT_MULTIRESPONSE_SURFACE,  PLOT_RESPONSE_SURFACE, GPC, GPC_EVALUATE

%   Noemi Friedman
%   Copyright 2015, Inst. of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

options=varargin2options(varargin);
[fixed_value, options]=get_option(options, 'fixed_value', 'mean');
check_unsupported_options(options,mfilename);

% Original gpc basis
sys = V_u{1};
I = V_u{2};
n_germ=size(I,2);

% Reduced gpc basis


%index of not fixed gpc germs:
fixed = find(~ismember(1:n_germ, dim_index));
ind = dim_index;

% Reduced polynomial system and multiindex set
sys_new=sys(ind);
I_new=I(:, ind);

% Fixed gpc_basis
sys_fixed=sys( fixed);
I_fixed=I(:, fixed);
V_fixed={sys_fixed, I_fixed};


% Evaluate gpc basis at the fixed value:
check_boolean(ischar(fixed_value), 'optional input FIXED_VALUE must be a string (either MEAN or QUANT)', mfilename);
switch fixed_value
    case 'mean'
        m_germ=length(fixed);
        val=zeros(m_germ, 1);
    case 'quant'
        val=gpcgerm_quantile(sys_fixed);
    otherwise
        error('sglib:gpc_reduce_basis_dim', 'optional input FIXED_VALUE can only be either MEAN or QUANT', mfilename);
end
u_i_fixed=gpcbasis_evaluate(V_fixed, val);

% Output
V_un={sys_new, I_new};
if isempty(u_i_alpha)
    u_i_alpha=ones(size(I,1), 1);
end
u_i_beta=binfun(@times, u_i_alpha, u_i_fixed');

