function [mean,var,skew,kurt]=pce_moments( r_i_alpha, I_r, varargin )
% PCE_MOMENTS Calculate the statistical moments of a distribution given as PCE.
%   [MEAN,VAR,SKEW,KURT]=PCE_MOMENTS( R_I_ALPHA, I_R ) calculate mean, variance,
%   skewness and kurtosis for a distribution given by the coefficients in
%   R_I_ALPHA. R_I_ALPHA can also be a field of PC expansions where R_I_ALPHA(i,:) is the
%   expansion at point x_i. The output arguments VAR, SKEW and KURT are
%   optional and only calculated if required. I_R contains
%   the (multi-) indices of the Hermite polynomials.
%
%   Caveat: Computations of skewness and kurtosis excess may be very slow.
%
% Example (<a href="matlab:run_example pce_moments">run</a>)
%   [r_i_alpha,I_r]=pce_expand_1d( @exp, 12 );
%   [mean,var,skew]=pce_moments( r_i_alpha, I_r );
%   [mean,var,skew]=lognormal_moments( 0, 1);
%
% See also PCE_EXPAND_1D, DATA_MOMENTS

%   Elmar Zander
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
[algorithm,options]=get_option( options, 'algorithm', 'mixed' );
check_unsupported_options(options,mfilename);

% changed: formerly it was possible to call this function with just one
% parameter, leading to subtle errors, because people just forgot to pass
% the second parameter, thinking it unncessary. Now, if the default (1d
% pce) shall be used, an empty array has to passed, making this choice
% explicit.
if isempty(I_r)
    I_r=multiindex( 1, size(r_i_alpha,2)-1 );
end

switch algorithm
    case 'mixed'
        mean=mean_direct( r_i_alpha, I_r );
        if nargout>=2
            var=var_direct( r_i_alpha, I_r );
        end
        if nargout>=3
            skew_raw=integrate_central_moment( r_i_alpha, I_r, 3 );
        end
        if nargout>=4
            kurt_raw=integrate_central_moment( r_i_alpha, I_r, 4 );
        end
    case 'pcemult'
        mean=mean_direct( r_i_alpha, I_r );
        if nargout>=2
            var=var_direct( r_i_alpha, I_r );
        end
        vals=cell(1,nargout-1);
        [vals{:}]=pcemult_moments( r_i_alpha, I_r );
        if nargout>=3
            skew_raw=vals{2};
        end
        if nargout>=4
            kurt_raw=vals{3};
        end
    case 'integrate'
        mean=integrate_central_moment( r_i_alpha, I_r, 1 );
        if nargout>=2
            var=integrate_central_moment( r_i_alpha, I_r, 2 );
        end
        if nargout>=3
            skew_raw=integrate_central_moment( r_i_alpha, I_r, 3 );
        end
        if nargout>=4
            kurt_raw=integrate_central_moment( r_i_alpha, I_r, 4 );
        end
end

if exist('skew_raw', 'var')
    skew=skew_raw./(var.^(3/2));
end
if exist('kurt_raw', 'var')
    kurt=kurt_raw./(var.^2)-3;
end


function m=integrate_central_moment( r_i_alpha, I_r, p )
p_r=max(multiindex_order(I_r));
if p>=2
    mean_ind = (multiindex_order(I_r)==0);
    r_i_alpha(:,mean_ind)=0;
end
p_int=ceil(p_r*(1+p)/2);
m=size(I_r,2);
m=integrate_nd( {@kernel,{p,r_i_alpha,I_r},{1,2,3}}, @gauss_hermite_rule, m, p_int );


function val=kernel( p, r_i_alpha, I_r, xi )
val=pce_evaluate(r_i_alpha,I_r,xi);
val=val.^p;


function mean=mean_direct( r_i_alpha, I_r )
mean_ind = (multiindex_order(I_r)==0);
mean = sum(r_i_alpha(:,mean_ind), 2);


function var=var_direct( r_i_alpha, I_r )
mean_ind = (multiindex_order(I_r)==0);
var=r_i_alpha(:,~mean_ind).^2*multiindex_factorial(I_r(~mean_ind,:));


function [var,skew,kurt]=pcemult_moments( r_i_alpha, I_r )
mean_ind = (multiindex_order(I_r)==0);
r_i_alpha(:,mean_ind)=0;

m=size(I_r,2);
p=max(I_r(:));
I_x=multiindex(m,2*p);
I_y=multiindex(m,0);
x_i_alpha=pce_multiply( r_i_alpha, I_r, r_i_alpha, I_r, I_x );
var=mean_direct(x_i_alpha, I_x);
y_i_alpha=pce_multiply( x_i_alpha, I_x, r_i_alpha, I_r, I_y );
skew=mean_direct(y_i_alpha, I_y);
if nargout>=3
    y_i_alpha=pce_multiply( x_i_alpha, I_x, x_i_alpha, I_x, I_y );
    kurt=mean_direct(y_i_alpha, I_y);
end

