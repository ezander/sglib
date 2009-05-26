%function [T_r,T_c,norm_r,norm_c,norm_f]=tensor_reduce( T, k0, eps, M1, M2 )
function [T_k,sig]=tensor_reduce( T, varargin )
% TENSOR_REDUCE Computes a reduced rank tensor product.
%
% Example (<a href="matlab:run_example tensor_reduce">run</a>)
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

options=varargin2options( varargin{:} );
[M1,options]=get_option( options, 'M1', [] );
[M2,options]=get_option( options, 'M2', [] );
[Sp,options]=get_option( options, 'Sp', 2 );
[k_max,options]=get_option( options, 'k_max', inf );
[eps,options]=get_option( options, 'eps', 1e-4 );
[relcutoff,options]=get_option( options, 'relcutoff', true );
check_unsupported_options( options, mfilename );

% relcutoff ||Sigma-Sigma_k||<=tol

if iscell(T)
    [Q1,R1]=qr_internal(T{1},M1);
    [Q2,R2]=qr_internal(T{2},M2);
    [U,S,V]=svd(R1*R2',0);
else
    [U,S,V]=svd(T,0);
end

sig=diag(S);
schatten_p=norm(sig,Sp);
if relcutoff
    eps=eps*schatten_p;
end

k0=length(sig);
k=1;
while k<=min(k_max,k0)
    schatten_p_trunc=norm(sig(k+1,end),Sp);
    if schatten_p_trunc<eps; break; end
    k=k+1;
end

U_k=U(:,1:k);
S_k=S(1:k,1:k);
V_k=V(:,1:k);
T_k={Q1*U_k*S_k,Q2*V_k};
%norm_r=norm(s(1:k_r),2);


function [Q,R]=qr_internal( A, M )
if isempty(M)
    [Q,R]=qr(A,0);
else
    [Q,R]=gram_schmidt(A,M,false,1);
end


