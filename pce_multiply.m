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
%   $Id$ 
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

% set up cache for triple products (structure coefficients)
hermite_triple_fast( max([I_X(:); I_Y(:); I_Z(:) ]) );

% now loop over all alphas, betas and gammas for the result
% TODO: this can most probably be optimized, e.g. maybe we can get at the
% coefficient matrix for one gamma and all alphas and betas and compute
% Z(gamma)=X'*C(gamma)*Y or similar. Another possibility would be to
% compute all products between X and Y and use something like ACCUMARRAY to
% assemble stuff.
n=size(X_alpha,1);
Z_gamma=zeros(n,size(I_Z,1));
for j=1:size(I_X,1)
    alpha=I_X(j,:);
    for k=1:size(I_Y,1)
        beta=I_Y(k,:);
        %c=hermite_triple_product( alpha, beta, gamma )/multiindex_factorial( gamma );
        if 1
            c=squeeze(hermite_triple_fast( alpha, beta, I_Z ))./multiindex_factorial( I_Z );
            i=find(c~=0);
            Z_gamma(:,i)=Z_gamma(:,i)+(X_alpha(:,j).*Y_beta(:,k))*c(i)';
        else
            for i=1:size(I_Z,1)
                gamma=I_Z(i,:);
                if all(mod(alpha+beta+gamma,2)==0) && ...
                        all(alpha<=beta+gamma) && ...
                        all(beta<=gamma+alpha) && ...
                        all(gamma<=alpha+beta)
                    c=hermite_triple_fast( alpha, beta, gamma )/multiindex_factorial( gamma );
                    Z_gamma(:,i)=Z_gamma(:,i)+c*X_alpha(:,j).*Y_beta(:,k);
                end
            end
        end
    end
end
