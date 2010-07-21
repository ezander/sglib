function [mean,var,skew,kurt]=kl_pce_moments( r_i_k, r_k_alpha, I_r, varargin )
% KL_PCE_MOMENTS no true documentation written so far.

% PCE_MOMENTS Calculate the statistical moments of a distribution given as PCE.
%   [MEAN,VAR,SKEW,KURT]=PCE_MOMENTS( R_I_ALPHA, I_R ) calculate mean, variance,
%   skewness and kurtosis for a distribution given by the coefficients in
%   R_I_ALPHA. R_I_ALPHA can also be a field of PC expansions where R_I_ALPHA(i,:) is the
%   expansion at point x_i. The output arguments VAR, SKEW and KURT are
%   optional and only calculated if required. I_R is optional and contains
%   the indices of the Hermite polynomials.
%
%   Caveat: Computations of skewness and kurtosis excess may be very slow.
%
% Example (<a href="matlab:run_example pce_moments">run</a>)
%   [r_i_alpha,I_r]=pce_expand_1d( @exp, 12 );
%   [mean,var,skew]=pce_moments( r_i_alpha );
%   [mean,var,skew]=pce_moments( r_i_alpha, I_r );
%   [mean,var,skew]=lognormal_moments( 0, 1);
%
% See also PCE_EXPAND_1D, DATA_MOMENTS

%   Elmar Zander
%   Copyright 2006, Institute of Scientific Computing, TU Braunschweig.
%   $Id$
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

% options=varargin2options(varargin);
% [algorithm,options]=get_option( options, 'algorithm', 'mixed' );
% check_unsupported_options(options,mfilename);


%mu_r_k=pce_moments( mu
%function 

% TODO: this is very primitive as yet and should use the tensor product
% structure. However, I need something working quick now.
switch nargout
    case {0,1}
        mean=r_i_k*r_k_alpha(:,1);
    case 2
        [mu_r_i,r_i_k,sigma_r_k,r_k_alpha]=kl_pce_to_standard_form(r_i_k,r_k_alpha,I_r);
        r_k_alpha(:,1)=0;
        mean=mu_r_i;
        var=(r_i_k.^2)*((sigma_r_k.^2).*((r_k_alpha.^2)*multiindex_factorial(I_r)));
    otherwise
        error( 'not yet implemented' );
end
