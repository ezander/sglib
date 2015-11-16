function [partial_var, I_s, ratio_by_index, ratio_by_order]=gpc_sobol_partial_vars(a_i_alpha, V_a, varargin)
% GPC_SOBOL_PARTIAL_VARS Compute the partial variances and optionally the Sobol sensitivities.
%   [PARTIAL_VAR, I_S]=GPC_SOBOL_PARTIAL_VARS(A_I_ALPHA, V_A) computes the
%   partial variances and Sobol sensitivities for the GPC given by the GPC
%   space V_A and the GPC coefficients A_I_ALPHA. Returned is a multiindex
%   set I_S with logical indices and PARTIAL_VAR containing the
%   corresponding partial variance for the indicated random variables. 
% 
%   When called like this: [PARTIAL_VAR, I_S, RATIO_BY_INDEX,
%   RATIO_BY_ORDER]=GPC_SOBOL_PARTIAL_VARS(A_I_ALPHA, V_A) also the ratios
%   of the variances with respect to the total variance are returned.
%
%   The output in detail:
%     PARTIAL_VAR(I,J) is the partial variance corresponding to the I_th
%       RV (given by coefficients A_I_ALPHA(I,:)) and the J-th index set in
%       I_S (given by I_S(J,:)). 
%       
%       I_S: index set defining the Sobol indices, such that e.g., if:
%         I_S(J,:)= [0, 1, 0, 0, 0], then the J_th row of PARTIAL_VAR
%         gives the partial variance for the first (because there is just
%         one nonzero element) sensitivity index of the SECOND (because
%         second element is the nonzero) GPC germ.
%           
%         I_S(J,:)=  [0, 1, 1, 0, 0] then the J_th row of PARTIAL_VAR gives
%         the partial variance for the SECOND (because there are two
%         nonzero elments) sensitivity index for evaluating the
%         sensitivities to the second and third GPC germs combined.
%
% Options:
%   MAX_INDEX: double, {inf}
%      Defines up to which Sobol index the partial variances are
%      calculated. Index 
% 
% Example (<a href="matlab:run_example gpc_sobol_partial_vars">run</a>)
%
%
% See also MULTIINDEX, GPC_BASIS_CREATE, GPC_MOMENTS

%   Noemi Friedman, Elmar Zander
%   Copyright 2006, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

options=varargin2options(varargin);
[max_index,options]=get_option( options, 'max_index', inf);
check_unsupported_options(options,mfilename);


% Get the multiindex set and convert to a logical array (having 1s where
% the original multiindex was nonzero; we'll call that logical index the
% 'Sobol index')
I_a=V_a{2};
I_s=logical(I_a);

% Get rid of all the indices with too high an order and of the mean
sobol_order = sum(I_s, 2);
ind = (sobol_order>0) & (sobol_order<=max_index);

I_a = I_a(ind, :);
I_s = I_s(ind, :);
a_i_alpha = a_i_alpha(:, ind);
V_a{2} = I_a;

% Calculate variance of the a_i_alpha*F_alpha polynomials
sqr_norm = gpcbasis_norm(V_a, 'sqrt', false);
var_row=binfun(@times, a_i_alpha.^2, sqr_norm');

% Get uniqe rows from Sobol indices
[I_s, ~, ind2]=unique(I_s, 'rows');

% Sum up the variances corresponding to one 'Sobol index' (note: every
% column in U (corresponding to the original index) .... )
M = gpcbasis_size(V_a, 1);
U = sparse(1:M, ind2, ones(1,M));
partial_var = var_row * U;

% Sort partial variances by Sobol order
order_criterion = [sum(I_s,2), fliplr(I_s)];
[~, sortind] = sortrows(order_criterion);
I_s = I_s(sortind, :);
partial_var=partial_var(:,sortind);

if nargout>=3
    % Compute the ratios
    ratio_by_index = binfun(@times, partial_var, 1./sum(partial_var,2));
    
    if nargout>=4
        % Compute the variance per Sobol order
        sobol_order = sum(I_s, 2);
        n = length(sobol_order);
        U = full(sparse(1:n, sobol_order, ones(1,n)));
        ratio_by_order = ratio_by_index * U;
    end
end
