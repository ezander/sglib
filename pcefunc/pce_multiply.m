function [Z_gamma,I_Z]=pce_multiply( X_alpha, I_X, Y_beta, I_Y, I_Z )
% PCE_MULTIPLY Multiply two PC expanded random variables.
%   [Z_GAMMA,I_Z]=PCE_MULTIPLY( X_ALPHA, I_X, Y_BETA, I_Y ) multiplies
%   X_ALPHA (with corresponding multiindex set I_X) and Y_BETA (with
%   corresponding multiindex set I_Y) to produce the PC expanded random
%   variable Z_GAMMA. The multindex set I_Z is generated such that all
%   nonzero terms can be represented.
%   [Z_GAMMA]=PCE_MULTIPLY( X_ALPHA, I_X, Y_BETA, I_Y, I_Z ) uses the
%   supplied multiindex set I_Z and computes only product terms referred to
%   in this set.
%   TODO: this method currently works only for scalar random variables.
%   Would be nice in the future if also vectors or random variable could be
%   multiplied in one step (like scalar times vector, or vectors
%   elementwise).
%
% Example (<a href="matlab:run_example pce_multiply">run</a>)
%   N=10; m=3; p_X=2; p_Y=4;
%   I_X=multiindex(m,p_X); X_alpha=rand(N,size(I_X,1)); 
%   I_Y=multiindex(m,p_Y); Y_beta=rand(N,size(I_Y,1)); 
%   [Z_gamma,I_Z]=pce_multiply( X_alpha, I_X, Y_beta, I_Y );
%
% See also PCE_EXPAND_1D, PCE_DIVIDE

%   Elmar Zander
%   Copyright 2006, Institute of Scientific Computing, TU Braunschweig.
%   $Id: pce_multiply.m 170 2009-07-20 12:49:50Z ezander $ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

% check number of arguments
error( nargchk( 3, 5, nargin ) );

% assume arguments
if nargin<4
    I_Y=I_X;
end

% check whether pc variables are specified correctly
if size(X_alpha,2)~=size(I_X,1)
    error( 'pc variable X_alpha and multiindex set I_X don''t match in pce_multiply' );
end
if size(Y_beta,2)~=size(I_Y,1)
    error( 'pc variable Y_beta and multiindex set I_Y don''t match in pce_multiply' );
end
if size(I_X,2)~=size(I_Y,2)
    error( 'multiindex sets I_X and I_Y don''t match in pce_multiply (different number of gaussians)' );
end

% compute the result multiindex set if necessary
ord_X=max( multiindex_order(I_X) );
ord_Y=max( multiindex_order(I_Y) );
if nargin<5
    ord_Z=ord_X+ord_Y;
    I_Z=multiindex( size(I_X,2), max( ord_Z ) );
end


% We try to solve here (for all g):
%   E[Z H_g]= E[X Y H_g]
% which gives due to orthogonality (and expand in the H_a,b,g)
%   Z_g = Sum_{a,b} E[X_a Y_b H_a H_b H_g]/E[H_g^2]
% With M=E[H_a H_b H_g] this gives
%   Z_g = Sum_{a,b} M_abg X_a Y_b / E[H_g^2]
% which can be written as some tensor multiplication / contraction with the
% order 3 tensor M of triple products

M=hermite_triple_fast( I_X, I_Y, I_Z );
n=size(X_alpha,1);

vectorized=true;
full=false;

if vectorized || full
    % The following shows the order of tensor multiplications and
    % contractions
    % tmp=MxY: [MX,MY,MZ]x[N,MY] & (contract on 2,2) => [MX,MZ,N]
    % Z=Xxtmp: [1,MX]x[MX,MZ,1] & (contract 2,1 ) => [1,MZ]
    Z_gamma_NN=tensor_multiply( X_alpha, tensor_multiply( M, Y_beta, 2, 2 ), 2, 1 );
    Z_gamma_NN=permute( Z_gamma_NN, [2 1 3] );
    if full
        Z_gamma=reshape( Z_gamm_NN, size(I_Z,1), [] );
    else
        ind=sub2ind( [n, n], 1:n, 1:n );
        Z_gamma=Z_gamma_NN(:,ind)';
    end
else
    Z_gamma=zeros(n,size(I_Z,1));
    for i=1:n
        % The following shows the order of tensor multiplications and
        % contractions
        % tmp=MxY: [MX,MY,MZ]x[N,MY] & (contract on 2,2) => [MX,MZ,N]
        % Z=Xxtmp: [1,MX]x[MX,MZ,1] & (contract 2,1 ) => [1,MZ]
        Z_gamma(i,:)=tensor_multiply( X_alpha(i,:), tensor_multiply( M, Y_beta(i,:), 2, 2 ), 2, 1 );
    end
end


Z_gamma=row_col_mult( Z_gamma, 1./multiindex_factorial(I_Z)' );
