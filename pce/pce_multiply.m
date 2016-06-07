function [z_k_gamma,I_z,M]=pce_multiply( x_i_alpha, I_x, y_j_beta, I_y, I_z, varargin )
% PCE_MULTIPLY Multiply two PC expanded random variables.
%   [Z_K_GAMMA,I_Z]=PCE_MULTIPLY( X_I_ALPHA, I_X, Y_J_BETA, I_Y ) multiplies
%   X_I_ALPHA (with corresponding multiindex set I_X) and Y_J_BETA (with
%   corresponding multiindex set I_Y) to produce the PC expanded random
%   variable Z_K_GAMMA. The multindex set I_Z is generated such that all
%   nonzero terms can be represented.
%   [Z_K_GAMMA]=PCE_MULTIPLY( X_I_ALPHA, I_X, Y_J_BETA, I_Y, I_Z ) uses the
%   supplied multiindex set I_Z and computes only product terms referred to
%   in this set.
%   X and Y must be defined on the same set of base random variables (i.e.
%   the second dimension of I_X and I_Y must be the same), however the
%   exact expansion (e.g. the order p of the expansion) may not be the
%   same. The first dimension of X and Y must be either the same or one of
%   them must be 1. With option 'full' (see below), both dimensions can be
%   different.
%
% Options
%   'full': Computes the "cartesian" product along the first dimension
%      instead of the pointwise. I.e. if SIZE(X_I_ALPHA,1)=NX and
%      SIZE(Y_J_BETA,1)=NY then SIZE(Z_K_GAMMA,1)=NX*NY.
%   'vectorized': true, {false}
%      Uses a fully vectorized algorithm, which can be faster if the
%      first of X_I_ALPHA and Y_J_BETA (i.e. size(I_X,1)) is small, but
%      wastes quite some memory. This algorithm first computes the full
%      product, and then takes only the diagonal of that.
%   'M': Pass in the multiplication tensor M, maybe previously returned
%      from the first call to this function, saving time for recomputing M.
%      M is only checked for dimensional consistency.
%  
% Example (<a href="matlab:run_example pce_multiply">run</a>)
%   N=10; m=3; p_X=2; p_Y=4;
%   I_x=multiindex(m,p_X); x_i_alpha=rand(N,size(I_x,1)); 
%   I_y=multiindex(m,p_Y); y_j_beta=rand(N,size(I_y,1)); 
%   [z_k_gamma,I_z]=pce_multiply( x_i_alpha, I_x, y_j_beta, I_y );
%
% See also PCE_EXPAND_1D, PCE_DIVIDE

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

% check number of arguments
check_num_args(nargin, 3, inf, mfilename );

% get options 
options=varargin2options( varargin );
[vectorized,options]=get_option( options, 'vectorized', false );
[full,options]=get_option( options, 'full', false );
[M,options]=get_option( options, 'M', [] );
check_unsupported_options( options, mfilename );

% assume arguments
if nargin<4 || isempty(I_y)
    I_y=I_x;
end

% check whether pc variables are specified correctly
if size(x_i_alpha,2)~=size(I_x,1)
    error( 'pc variable x_i_alpha and multiindex set I_x don''t match in pce_multiply' );
end
if size(y_j_beta,2)~=size(I_y,1)
    error( 'pc variable y_j_beta and multiindex set I_y don''t match in pce_multiply' );
end
if size(I_x,2)~=size(I_y,2)
    error( 'multiindex sets I_x and I_y don''t match in pce_multiply (different number of gaussians)' );
end

% compute the result multiindex set if necessary
ord_X=max( multiindex_order(I_x) );
ord_Y=max( multiindex_order(I_y) );
if nargin<5 || isempty(I_z)
    ord_Z=ord_X+ord_Y;
    I_z=multiindex( size(I_x,2), max( ord_Z ) );
end


% We try to solve here (for all g):
%   E[Z H_g]= E[X Y H_g]
% which gives due to orthogonality (and expand in the H_a,b,g)
%   Z_g = Sum_{a,b} E[X_a Y_b H_a H_b H_g]/E[H_g^2]
% With M=E[H_a H_b H_g] this gives
%   Z_g = Sum_{a,b} M_abg X_a Y_b / E[H_g^2]
% which can be written as some tensor multiplication / contraction with the
% order 3 tensor M of triple products

if isempty( M )
    M=hermite_triple_fast( I_x, I_y, I_z );
else
    if size(M,1)~=size(I_x,1) || size(M,2)~=size(I_y,1) || size(M,3)~=size(I_z,1) 
        error( 'sglib:pce_multiply:mismatch', 'Dimension mismatch: multiplication tensor does not match the given multiindex sets' );
    end
end
n=size(x_i_alpha,1);


if vectorized || full
    % The following shows the order of tensor multiplications and
    % contractions and permutations
    % tmp=M x Y: [Mx,My,Mz]x[Ny,My] & (contract on 2,2) => [Mx,Mz,Ny]
    % Z=X x tmp: [Nx,Mx]x[Mx,Mz,Ny] & (contract 2,1 ) => [Nx,Mz,Ny]
    % permute Z from [Nx,Mz,Ny] to [Nx,Ny,Mz] or [Mz,Nx,Ny]
    if full
        z_i_gamma_j=tensor_multiply( x_i_alpha, tensor_multiply( M, y_j_beta, 2, 2 ), 2, 1 );
        z_i_j_gamma=permute( z_i_gamma_j, [1 3 2] );
        z_k_gamma=reshape( z_i_j_gamma, [], size(I_z,1) );
    else
        y_i_gamma_j=tensor_multiply( M, y_j_beta, 2, 2 );
        
        z_i_gamma_j=tensor_multiply( x_i_alpha, tensor_multiply( M, y_j_beta, 2, 2 ), 2, 1 );
        z_gamma_i_j=permute( z_i_gamma_j, [2 1 3] );
        ind=sub2ind( [n, n], 1:n, 1:n );
        z_k_gamma=z_gamma_i_j(:,ind)';
    end
else
    z_k_gamma=zeros(n,size(I_z,1));
    for i=1:n
        % The following shows the order of tensor multiplications and
        % contractions
        % tmp=M x Y: [Mx,My,Mz]x[Ny,My] & (contract on 2,2) => [Mx,Mz,Ny]
        % Z=X x tmp: [1,Mx]x[Mx,Mz,1] & (contract 2,1 ) => [1,Mz]
        z_k_gamma(i,:)=tensor_multiply( x_i_alpha(i,:), tensor_multiply( M, y_j_beta(i,:), 2, 2 ), 2, 1 );
    end
end
z_k_gamma=row_col_mult( z_k_gamma, 1./multiindex_factorial(I_z)' );
