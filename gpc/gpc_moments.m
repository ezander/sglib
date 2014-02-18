function [mean,var,skew,kurt]=gpc_moments( r_i_alpha, V_r, varargin )
% GPC_MOMENTS Calculate the statistical moments of a distribution given as GPC.
%   [MEAN,VAR,SKEW,KURT]=GPC_MOMENTS( R_I_ALPHA, V_R, OPTIONS ) calculate mean,
%   variance, skewness and kurtosis for a distribution given by the
%   coefficients in R_I_ALPHA. R_I_ALPHA can also be a field of GPC
%   expansions where R_I_ALPHA(i,:) is the expansion at point x_i. The
%   output arguments VAR, SKEW and KURT are optional and only calculated if
%   required. V_R contains the GPC space, i.e. a specification of the
%   orthogonal polynomials and the multiindex set used.
%   
% Options
%   'var_only': {false}, true
%      If set, only the variance is returned, i.e. the calling syntac then
%      is VAR=GPC_MOMENTS( R_I_ALPHA, V_R, 'VAR_ONLY', TRUE ).
%   'algorithm': {'mixed'}, 'integrate
%      Choose algorithm to be used.
%
% Example (<a href="matlab:run_example gpc_moments">run</a>)
%   a_dist = gendist_create('beta', {1.2, 2});
%   [mean,var,skew,kurt]=gendist_moments(a_dist);
%   fprintf('Moments (true):\nmean=%g, var=%g, skew=%g, kurt=%g\n', mean, var, skew, kurt)
%
%   [a_alpha, V, err] = gpc_param_expand(a_dist, 'u', 'varerr', 0.001, 'fixvar', true);
%   [mean,var,skew,kurt]=gpc_moments(a_alpha, V);
%   fprintf('Moments (gpc): \nmean=%g, var=%g, skew=%g, kurt=%g\n', mean, var, skew, kurt)
%
% See also GPC, GPC_INTEGRATE

%   Elmar Zander
%   Copyright 2013, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

options=varargin2options(varargin);
[algorithm,options]=get_option( options, 'algorithm', 'mixed' );
[var_only,options]=get_option( options, 'var_only', false );
check_unsupported_options(options,mfilename);

if var_only && nargout>1
    error('sglib:gpc_moments', 'Only one output parameter allowed if "var_only" is set');
end

compute_var = nargout>=2 || var_only;
compute_skew = nargout>=3 && ~var_only;
compute_kurt = nargout>=4 && ~var_only;

switch algorithm
    case 'mixed'
        mean=mean_direct( r_i_alpha, V_r );
        if compute_var
            var=var_direct( r_i_alpha, V_r );
        end
        if compute_skew
            skew_raw=integrate_central_moment( r_i_alpha, V_r, 3 );
        end
        if compute_kurt
            kurt_raw=integrate_central_moment( r_i_alpha, V_r, 4 );
        end
    case 'integrate'
        mean=integrate_central_moment( r_i_alpha, V_r, 1 );
        if compute_var
            var=integrate_central_moment( r_i_alpha, V_r, 2 );
        end
        if compute_skew
            skew_raw=integrate_central_moment( r_i_alpha, V_r, 3 );
        end
        if compute_kurt
            kurt_raw=integrate_central_moment( r_i_alpha, V_r, 4 );
        end
end

if exist('skew_raw', 'var')
    skew=skew_raw./(var.^(3/2));
end
if exist('kurt_raw', 'var')
    kurt=kurt_raw./(var.^2)-3;
end

if var_only
    mean = var;
end

function mean=mean_direct( r_i_alpha, V_r )
% MEAN_DIRECT Compute the mean of a GPC directly from the coefficients
I_r = V_r{2};
mean_ind = (multiindex_order(I_r)==0);
mean = sum(r_i_alpha(:,mean_ind), 2);


function var=var_direct( r_i_alpha, V_r )
% VAR_DIRECT Compute the variance of a GPC directly from the coefficients
I_r = V_r{2};
mean_ind = (multiindex_order(I_r)==0);
sqr_norm = gpcbasis_norm(V_r, 'sqrt', false);
var=r_i_alpha(:,~mean_ind).^2 * sqr_norm(~mean_ind);


function m=integrate_central_moment( r_i_alpha, V_r, p )
% INTEGRATE_CENTRAL_MOMENT Compute p-th central moment(s) of a GPC
I_r = V_r{2};
p_r=max(multiindex_order(I_r));
if max(p)>=2
    mean_ind = (multiindex_order(I_r)==0);
    r_i_alpha(:,mean_ind)=0;
end
p_int=ceil(p_r*(1+max(p))/2);
m=gpc_integrate({@kernel, {p}, {1}}, V_r, p_int, 'gpc_coeffs', r_i_alpha);


function val=kernel(p, r_i)
% KERNEL Kernel for evaluating p-th moments
val=r_i.^p;
