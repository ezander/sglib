%function [T_r,T_c,norm_r,norm_c,norm_f]=tensor_reduce( T, k0, eps, M1, M2 )
function [T_r]=tensor_reduce( T, varargin )
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
[M1,options]=get_options( options, 'M1', [] );
[M2,options]=get_options( options, 'M2', [] );
[Sp,options]=get_options( options, 'Sp', 2 );
[k_max,options]=get_options( options, 'k_max', inf );
[eps,options]=get_options( options, 'eps', 1e-4 );
[relcutoff,options]=get_options( options, 'relcutoff', true );
check_unsupported_options( options, mfilename );

% relcutoff ||Sigma-Sigma_k||<=tol


[Q1,R1]=qr_internal(T{1},M1);
[Q2,R2]=qr_internal(T{2},M2);

[U,S,V]=svd(R1*R2',0);
s=diag(S);
norm_f=norm(s,2);
min_s=min(eps,norm_f*eps);
k_r=min(k0,sum(s>=min_s));

U_r=U(:,1:k_r);
S_r=S(1:k_r,1:k_r);
V_r=V(:,1:k_r);
T_r={Q1*U_r*S_r,Q2*V_r};
norm_r=norm(s(1:k_r),2);

if nargout>1
    min_s2=min(eps^2,norm_r*eps^2); %or max(s)*eps instead of norm? option?
    k_c=min(k_r+k0,sum(s>=min_s2)); % or 2*k0 instead of k_r+k0
    U_c=U(:,k_r+1:k_c);
    S_c=S(k_r+1:k_c,k_r+1:k_c);
    V_c=V(:,k_r+1:k_c);
    T_c={Q1*U_c*S_c,Q2*V_c};
    norm_c=norm(s(k_r+1:k_c),2);
end


function [Q,R]=qr_internal( A, M )
if isempty(M)
    [Q,R]=qr(A,0);
else
    [Q,R]=gram_schmidt(A,M,false,1);
end
