function [u_alpha,I_u]=pce_transform_multi( g, u_i, varargin )
% PCE_TRANSFORM_MULTI Transform from local univariate to global
% multivariate PCE.
%   [U_ALPHA,I_U]=PCE_TRANSFORM_MULTI( G, U_I ) transforms a univariate PCE
%   expansion given in U_I (i.e. containing the local univariate PCE
%   coefficients, currently only stationary) and an underlying Gaussian
%   field specifying the covariance structure given by the functions in G
%   (which are gained from the KL eigenfunction by multiplying with the
%   square root of the lambdas) into a multivariate PCE U_ALPHA where
%   U_ALPHA(:,i) is the multivariate PC expansion at point i in as many
%   independent Gaussian RVs as there are KL eigenfunctions. I_U contains
%   on return the indices of the multivariate Hermite polynomials.
%
% Options:
%   fast: {true}, false
%     Specifies that a vectorized code is run, which does some "unnecessary"
%     logarithms and exponentials, but is much faster in Matlab.

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


%TODO: make pce_transform_multi adhere to naming conventions

% Put options into structure
options=varargin2options( varargin );
[fast,options]=get_option( options, 'fast', false );
check_unsupported_options( options, mfilename );

% determine number of points and order of KL and PCE
n=size(g,1);
m=size(g,2);
p=size(u_i,2)-1;

% create a multiindex of appropriate size and initialize the index vector
I_u=multiindex(m,p);

if ~fast
    % perform the safe unvectorized method (this is probably the more
    % appropriate code to translate into a decent programming language...)
    u_alpha=zeros(n,size(I_u,1));
    for i=1:size(I_u,1)
        % get i-th multiindex and determines its order
        alpha=I_u(i,:);
        p_alpha=multiindex_order( alpha );

        % this here corresponds to a relation on multivariate Hermite
        % polynmials which is really awkward to write as a Matlab comments
        % (maybe later I'll try this...)
        factor=factorial( p_alpha )/multiindex_factorial( alpha )...
            *u_i( p_alpha+1 );
        fun=ones(n,1);
        for j=1:m
            alpha_j=alpha(j);
            if alpha_j~=0
                fun=fun .* g(:,j).^alpha_j;
            end
        end
        u_alpha(:,i)=factor*fun;
    end
else
    % Options: FAST - vectorized code
    % In order to vectorize the exponentiation with the multiindex we have
    % to take logarithms and thus transform it into a scalar product with
    % the exponents (i.e. a1^b1*a2^b2*...= exp( log(a1)*b1+log(a2)*b2+...)
    p_alpha=multiindex_order( I_u );
    factor=factorial( p_alpha )./multiindex_factorial( I_u ).*...
        u_i( p_alpha+1 )';
    u_alpha=row_col_mult( real(exp(log(g)*I_u')), factor' );
end
