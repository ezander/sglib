function [part_vars, I_un, ratios, ratio_per_order]=gpc_sobol_partial_vars(V_a, a_i_alpha, varargin)
% GPC_SOBOL_PARTIAL_VARS Compute the partial variances and optionally the Sobol sensitivities.
%   [PART_VARS, I_UN, SOBOL_SENSITIVITY]=
%       =GPC_SOBOL_PARTIAL_VARSs(V_U, A_I_ALPHA, 'max_index', 2)
%   with inputs:
%       V_A ={POLYSYS, I_A}: the gpc basis with POLYSYS (polynomial system
%       description) and I_A (multiindex set)
%       A_I_ALPHA: The coefficients of the polynomial
%   optional input:
%       MAX_INDEX: defines up to which Sobol index the partial variances are calculated 
%   output:
%       PART_VARS_ij: are the partial variances corresponding to the i_th
%           index set in I_UN and to the jth RV
%           Note, the partial variances are ordered, so that the first rows
%           corresponds to the univariate polynoamils
%           (the first Sobol index), the following rows to the bivariate (second Sobol index), etc. 
%       
%       I_UN: index set defining the Sobol basis,
%       Example1:
%        I_UN(i,:)= [0, 1, 0, 0, 0]
%           the i_rh row of PART_VARS gives the partial variance for
%           the first (because there is just one nonzero element)
%           sensitivity index of the SECOND (because 
%           second element is the nonzero) gpc germ 
%           
%        I_UN(i,:)=  [0, 1, 1, 0, 0]
%           then the i_rh row of PART_VARS gives the partial variance for
%           the SECOND (because there are two nonzero elments)
%           sensitivity index for evaluating the sensitivities to the
%           second and third germs combined
%
% Example (<a href="matlab:run_example gpc_sobol_partial_vars">run</a>)
%
%
% See also MULTIINDEX, GPC_BASIS_CREATE, GPC_MOMENTS

%   Noemi Friedman and Elmar Zander
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
I_un=boolean(I_a);

% Get rid of all the indices with too high an order and of the mean
sob_order = sum(I_un, 2);
ind = (sob_order>0) & (sob_order<=max_index);

I_a = I_a(ind, :);
I_un = I_un(ind, :);
a_i_alpha = a_i_alpha(:, ind);
V_a{2} = I_a;

% Calculate variance of the a_i_alpha*F_alpha polynomials
sqr_norm = gpcbasis_norm(V_a, 'sqrt', false);
var_row=binfun(@times, a_i_alpha.^2, sqr_norm');

% Get uniqe rows from Sobol indices
[I_un, ~, ind2]=unique(I_un, 'rows');

% Sum up the variances corresponding to one 'Sobol index' (note: every
% column in U (corresponding to the original index) .... )
M = gpcbasis_size(V_a, 1);
U = sparse(1:M, ind2, ones(1,M));
part_vars = (var_row * U)';

% Sort partial variances by Sobol order
fake = [sum(I_un,2), fliplr(I_un)];
[~, sortind] = sortrows(fake);
I_un = I_un(sortind, :);
part_vars=part_vars(sortind,:);

if nargout>=3
    % Compute the ratios
    ratios = binfun(@times, part_vars, 1./sum(part_vars,1));
    
    if nargout>=4
        % Compute the variance per Sobol order
        sob_order = sum(I_un, 2);
        n = length(sob_order);
        U = sparse(1:n, sob_order, ones(1,n));
        ratio_per_order = U' * ratios;
    end
end
