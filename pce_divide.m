function [Z_gamma,I_Z]=pce_divide( X_alpha, I_X, Y_beta, I_Y, I_Z )
% PCE_DIVIDE Divide two PC expanded random variables.
%   [Z_GAMMA,I_Z]=PCE_DIVIDE( X_ALPHA, I_X, Y_BETA, I_Y ) divides
%   X_ALPHA (with corresponding multiindex set I_X) by Y_BETA (with
%   corresponding multiindex set I_Y) to produce the PC expanded random
%   variable Z_GAMMA. If I_Z is not specified I_Z==I_X is assumed. Since
%   X/Y can usually not be represented exactly, the Galerkin projection is
%   computed.
%
% Example (<a href="matlab:run_example pce_multiply">run</a>)
%   N=10; m=3; p_X=2; p_Y=4;
%   I_X=multiindex(m,p_X); X_alpha=rand(N,size(I_X,1)); 
%   I_Y=multiindex(m,p_Y); Y_beta=rand(N,size(I_Y,1)); 
%   [Z_gamma,I_Z]=pce_divide( X_alpha, I_X, Y_beta, I_Y );
%
% See also PCE_EXPAND_1D, PCE_MULTIPLY

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

if nargin<5
    I_Z=I_X;
end

m_Z=size(I_Z,1);
X_alpha_RHS=compute_pce_rhs( X_alpha, I_X, I_Z );

K=compute_pce_matrix( Y_beta, I_Y, I_Z );

n=size(Y_beta,1);
m=size(X_alpha,1);
if n==1
    Z_gamma=(K\X_alpha_RHS')';
elseif n==m || m==1
    Z_gamma=zeros(n,m_Z);
    for i=1:n
        if n==m; j=i; else j=1; end
        Z_gamma(i,:)=(K(:,:,i)\X_alpha_RHS(j,:)')';
    end
else 
    error('so nich...')
end
