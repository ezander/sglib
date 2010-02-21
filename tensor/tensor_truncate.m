function [T_k,sigma,k]=tensor_truncate( T, varargin )
% TENSOR_TRUNCATE Computes a truncated rank tensor product.
%   [T_K,SIGMA,K]=TENSOR_TRUNCATE( T, OPTIONS ) truncates the tensor T to a
%   rank K approximation T_K. SIGMA contains the singular values of T, and
%   K the rank of the approximation that was determined by choice of
%   parameters.
%
% Options:
%   p: 2
%   k_max: inf
%   eps: 0
%   relcutoff: true
%
% Example (<a href="matlab:run_example tensor_truncate">run</a>)
%   % still to come
%
% See also TENSOR_ADD

%   Elmar Zander
%   Copyright 2007, Institute of Scientific Computing, TU Braunschweig.
%   $Id$
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

options=varargin2options( varargin );
[G,options]=get_option( options, 'G', {} );
[p,options]=get_option( options, 'p', 2 );
[k_max,options]=get_option( options, 'k_max', inf );
[eps,options]=get_option( options, 'eps', 0 );
[relcutoff,options]=get_option( options, 'relcutoff', true );
check_unsupported_options( options, mfilename );

if isnumeric(T)
    [U,S,V]=svd(T,0);
    [T_k,sigma,k]=tensor_truncate_2( {U*S,V}, G, eps, k_max, relcutoff, p );
    T_k=T_k{1}*T_k{2}';
elseif iscell(T)
    if length(T)==2
        [T_k,sigma,k]=tensor_truncate_2( T, G, eps, k_max, relcutoff, p );
    else
        U=ktensor( T );
        OPTS.tol=eps;
        OPTS.maxiters=50;
        OPTS.dimorder=1:length(T);
        OPTS.init='random';
        OPTS.printitn=10;
        U_k=cp_als( U, k_max, OPTS );
        lambda=U_k.lambda(:);
        T_k=U_k.u';
        T_k{1}=row_col_mult( T_k{1}, lambda' );
        if any(isnan(double(U_k)))
            keyboard;
        end
    end
elseif isobject(T)
        OPTS.tol=eps;
        OPTS.maxiters=50;
        %OPTS.dimorder=1:length(T);
        OPTS.init='random';
        OPTS.printitn=10;
        T_k=cp_als( T, k_max, OPTS );
        if any(isnan(double(T_k)))
            keyboard;
        end
else
    error( 'tensor:tensor_truncate:tensor_format', 'Unknown tensor format' );
end


function [T_k,sigma,k]=tensor_truncate_2( T, G, eps, k_max, relcutoff, p )
if isempty(G); G={[],[]}; end
[Q1,R1]=qr_internal(T{1},G{1});
[Q2,R2]=qr_internal(T{2},G{2});
[U,S,V]=svd(R1*R2',0);

sigma=diag(S);
k=schattenp_truncate( sigma, eps, relcutoff, p );
k=min(k,k_max);

U_k=U(:,1:k);
S_k=S(1:k,1:k);
V_k=V(:,1:k);

T_k={Q1*U_k*S_k,Q2*V_k};


function [Q,R]=qr_internal( A, G )
if isempty(G)
    [Q,R]=qr(A,0);
else
    [Q,R]=gram_schmidt(A,G,false,1);
end

function k=schattenp_truncate( sigma, eps, rel, p )

if isfinite(p)
    csp=cumsum(sigma.^p);
    if rel; eps=eps*csp(end); end
    k=find(csp(end)-csp<=eps^p,1,'first');
else
    if rel; eps=eps*sigma(end); end
    k=sum(sigma>=eps);
end
