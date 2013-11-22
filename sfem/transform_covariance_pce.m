function C_gam=transform_covariance_pce( C_u, pcc_u, varargin )
% TRANSFORM_COVARIANCE_PCE Transforms covariance of underlying Gaussian
% field.
%   C_gam=TRANSFORM_COVARIANCE_PCE( C_U, PCC_U ) transforms the values of the
%   covariance of the original variable given in the covariance matrix C_U
%   to that of the Gaussian base field. The covariance matrix for the base
%   field is returned in C_GAM. PCC_U containes the coefficients of the PCE
%   of the random field. If the PCE is non-stationary an array of
%   coefficients has to be passed to this function where PCC_U(:,i) contains
%   the PCE coefficients at point x_i.
%
% Options:
%   correct_var: true, {false}
%     If C_U is normalized it is corrected before the transformation is
%     done (i.e. C_U is scaled with the variance which will be computed
%     from PCC_U). Works only for stationary fields.
%   comp_ii_check: {true}, false
%     does a check for type II incompatibility after the transformation
%     (i.e. negative covariance matrix of the "Gaussian" process). KL on
%     such a process will fail.
%   comp_ii_reltol: {1e-4}
%     Usually there will be small negative eigenvalues for large
%     covariance matrices, which will be no problem if the KL is
%     truncated before. This options specifies the maximum negative
%     tolerance.
%
% Example (<a href="matlab:run_example transform_covariance_pce">run</a>)
%
% See also OPTIONS

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


% TODO: in the stationary case it may be more efficient to compute the
% real root of the polynomial for some N points in the range spanned by
% the original covariance and interpolate in between.

%TODO: check whether the variance of the marginal densities given via pcc_u
%and the covariances given via C_u match (for the entries on the diagonal)

% get options
options=varargin2options( varargin );
[correct_var,options]=get_option( options, 'correct_var', false );
[interpolate,options]=get_option( options, 'interpolate', true);
[comp_ii_check,options]=get_option( options, 'comp_ii_check', true );
[comp_ii_reltol,options]=get_option( options, 'comp_ii_reltol', 1e-4 );
check_unsupported_options( options, mfilename );

% if the pce is stationary precompute the transformation polynomial
if size(pcc_u,1)==1
    stationary=true;
    p=gen_cov_poly( pcc_u, 1, 1 );
else
    stationary=false;
end


% correct C_u if necessary
if correct_var
    if ~stationary
        error( 'transform_covariance_pce:instationary', ...
	      'correction of C_u not possible for instationary fields' );
    end
    [mu,sig2]=pce_moments( pcc_u, [] );
    mu; %#ok: mu unused
    C_u=C_u*sig2;
end

if ~stationary || ~interpolate
    C_gam=zeros(size(C_u));
    for i=1:size(C_u,1)
        for j=i:size(C_u,2)
            if stationary
                q=p;
            else
                q=gen_cov_poly( pcc_u, i, j );
            end
            q(end)=-C_u(i,j);
            C_gam(i,j)=findroot( q );
            if i~=j
                C_gam(j,i)=C_gam(i,j);
            end
        end
    end
else
    s_u1=min(C_u(:));
    s_u2=max(C_u(:));
    N=100;
    s_u=linspace(s_u1,s_u2,N);
    s_gam=zeros(1,N);
    for i=1:N
        q=p;
        q(end)=-s_u(i);
        s_gam(i)=findroot( q );
    end
    C_gam=interp1( s_u, s_gam, C_u(:), 'pchip' );
    C_gam=reshape( C_gam, size(C_u) );
end


if comp_ii_check
    lambda=eig(C_gam);
    if min(lambda)< -1*comp_ii_reltol*max(abs(lambda))
        warning( 'transform_covariance_pce:negative', ...
        ['Transformed cov. matrix is not non-negative definite (type II incompatibility between cov. and marg densities)\n', ...
        'lambda_max: %g, lambda_min: %g size: %d num_negative: %d'], max(lambda), min(lambda), length(lambda), sum(lambda<0));
    end
end

function p=gen_cov_poly( pcc_u, i, j )
% GEN_COV_POLY Generate transformation polynomial between points i and j.
M=size(pcc_u,2);
K=M:-1:1;
p=factorial(K-1).*pcc_u(i,K).*pcc_u(j,K);
p(end)=0;

function r=findroot( p )
% FINDROOT Find the real root in [-1,1] of a polynomial.
if 1==1
    % Using "roots" seems to be somewhat faster in Matlab than determining
    % just the one real root
    rs=roots(p);
    % we extend the interval a little bit to account for numerical errors
    ind=(rs>=-1.1) & (rs<=1.1) & (imag(rs)==0);
    r=unique(rs(ind));
    if isempty(r)
        % This ususally happens if there is a type I incompatibility
        % between the marginal densities and the covariance function; maybe
        % you should check whether they match...
        error( 'transform_covariance_pce:findroot', [ 'the inverse of ' ...
            'the transform polynomial could not be found.' ] );
    elseif length(r)>1
        error( 'transform_covariance_pce:findroot', [ 'the inverse of ' ...
            'the transform polynomial is not unique.' ] );
    end
else
    % Laguerre's method (should converge cubically);
    % For an explanation of the algorithm see e.g.
    % http://en.wikipedia.org/wiki/Laguerre%27s_method
    dp=polyder(p);
    ddp=polyder(dp);
    r=0.5;
    n=length(p)-1;
    while true
        px=polyval(p,r);
        if abs(px)<1e-10; break; end;
        G=polyval(dp,r)/px;
        H=G^2-polyval(ddp,r)/px;
        U=sqrt((n-1)*(n*H-G^2));
        if abs(G+U)>abs(G-U)
            a=n/(G+U);
        else
            a=n/(G-U);
        end;
        r=r-a;
    end
end

