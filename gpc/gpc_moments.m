function [mean,var,skew,kurt]=gpc_moments( r_i_alpha, V_r, varargin )
% GPC_MOMENTS Calculate the statistical moments of a distribution given as GPC.
%   [MEAN,VAR,SKEW,KURT]=GPC_MOMENTS( R_I_ALPHA, V_R ) calculate mean,
%   variance, skewness and kurtosis for a distribution given by the
%   coefficients in R_I_ALPHA. R_I_ALPHA can also be a field of GPC
%   expansions where R_I_ALPHA(i,:) is the expansion at point x_i. The
%   output arguments VAR, SKEW and KURT are optional and only calculated if
%   required. V_R contains the GPC space, i.e. a specification of the
%   orthogonal polynomials and the multiindex set used.
%
% Example (<a href="matlab:run_example gpc_moments">run</a>)
%
% See also GPC

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
check_unsupported_options(options,mfilename);

switch algorithm
    case 'mixed'
        mean=mean_direct( r_i_alpha, V_r );
        if nargout>=2
            var=var_direct( r_i_alpha, V_r );
        end
        if nargout>=3
            skew_raw=integrate_central_moment( r_i_alpha, V_r, 3 );
        end
        if nargout>=4
            kurt_raw=integrate_central_moment( r_i_alpha, V_r, 4 );
        end
    case 'integrate'
        mean=integrate_central_moment( r_i_alpha, V_r, 1 );
        if nargout>=2
            var=integrate_central_moment( r_i_alpha, V_r, 2 );
        end
        if nargout>=3
            skew_raw=integrate_central_moment( r_i_alpha, V_r, 3 );
        end
        if nargout>=4
            kurt_raw=integrate_central_moment( r_i_alpha, V_r, 4 );
        end
end

if exist('skew_raw', 'var')
    skew=skew_raw./(var.^(3/2));
end
if exist('kurt_raw', 'var')
    kurt=kurt_raw./(var.^2)-3;
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
sqr_norm = gpc_norm(V_r, 'sqrt', false);
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


function val=kernel( p, xi, r_i ) %#ok<INUSL>
% KERNEL Kernel for evaluating p-th moments
val=r_i.^p;
