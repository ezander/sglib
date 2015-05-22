function [part_vars, I_un, varargout]=gpc_sobol_partial_vars(V_a, a_i_alpha, varargin)
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
% Example (<a href="matlab:run_example multiindex_order">run</a>)
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
[max_index,options]=get_option( options, 'max_index', []);
check_unsupported_options(options,mfilename);

Q=gpcbasis_size(V_a,2);
num_vars=size(a_i_alpha,1);

%%
polysys=V_a{1};
I_a=V_a{2};
% get read of the constant term
mean_ind = (multiindex_order(I_a)==0);
I_a=I_a(~mean_ind,:);
a_i_alpha=a_i_alpha(:,~mean_ind);

% calculate variance of the a_i_alpha*Fi_ alpha_i polynomials
sqr_norm = gpcbasis_norm({polysys, I_a}, 'sqrt', false);
var_row=a_i_alpha.^2 .* repmat(sqr_norm', size(a_i_alpha,1),1);

% change all nonzero elements to one
I_un=I_a;
I_un(~(I_a==0))=1;
% get uniqe rows
[I_un, ~, ind2]=unique(I_un, 'rows'); %I_un(ind2,:) this is how to get back the I

% number of partials
n=size(I_un,1);
% prelocate memory for partial variances
part_vars=zeros(n,num_vars);
for i=1:n
    ind=find(ind2==i);
    part_vars(i,:)=sum(var_row(:, ind),2);
end

%% sort partials by  Sobolev index
sob_ind=sum(I_un,2);
[sob_ind, ind]=sort(sob_ind);

I_un=I_un(ind,:);
part_vars=part_vars(ind,:);


% Get rid of rows with higher indices
ind=sob_ind<=max_index;
I_un=I_un(ind,:);
part_vars=part_vars(ind,:);
sob_ind=sob_ind(ind);

% Calculate total variance and prelocate memory for sobol index
% (part_vars/tot_vars) and for ratios (sum part_vars/tot_vars
if nargout==3
    sob_sensitivity=zeros(size(part_vars));
    tot_var=gpc_moments(a_i_alpha, {polysys, I_a}, 'var_only', true);
    ratios_i=zeros(max(sob_ind), num_vars);
end

% sort within specific indices
for i=1:max(sob_ind)
    %rows corresponding to the ith sobolev index
    row_ind_i=(sob_ind==i);
    %the indices corresponding to ith sobolev index
    I_un_i=I_un(row_ind_i,:);
    %the variances corresponding to the ith sobolev index
    part_vars_i=part_vars(row_ind_i,:);
    %sort rows
    [~,ind_sort]=sortrows(I_un_i);
    %Sorte indices and variances
    I_un(row_ind_i,:)=I_un_i(flipud(ind_sort),:);
    part_vars(row_ind_i,:)=part_vars_i(flipud(ind_sort),:);
    
    if nargout==3
        sob_sensitivity(row_ind_i,:)=part_vars(row_ind_i,:)./repmat(tot_var',sum(row_ind_i),1);
        ratios_i(i,:)=sum(sob_sensitivity(row_ind_i,:));
    end
end
if nargout==3
    varargout{1}={sob_sensitivity, ratios_i};
end
end

