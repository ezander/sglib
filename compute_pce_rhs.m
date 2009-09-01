function f_j_beta=compute_pce_rhs( f_j_alpha, I_f, I_u )
%COMPUTE_PCE_RHS Compute the right hand side in a linear equation involving the PCE.
%   Suppose the equation K*U=F has to be solved for U where F and U are PC
%   expanded random variables and the the equation has to solved in the
%   Galerkin sense. Then it is required that E[K*U*H_beta]=E[F*H_beta]
%   for all H_alpha in the ansatz space of U. 
%   COMPUTE_PCE_RHS( F_J_ALPHA, I_F, I_U ) computes E[F*H_beta] for each
%   beta in I_U where F_J_ALPHA is expanded with respect to all H_alpha for
%   alpha in I_F. If I_U is omitted I_U==I_F is assumed.
%
% Example (<a href="matlab:run_example compute_pce_rhs">run</a>)
%   I_a=[0 0; 1 0; 0 2; 3 4]; % some multiindices
%   I_b=[3 4; 1 1; 0 2; 0 0; 4 4]; % random permutation of I_a + some more
%   a_alpha=[1 2 3 4; 5 6 7 8]; % pce coefficient w.r.t. I_a
%   disp( compute_pce_rhs( a_alpha, I_a, I_b ) );
%
% See also COMPUTE_PCE_MATRIX, COMPUTE_PCE_OPERATOR

%   Elmar Zander
%   Copyright 2009, Inst. of Scientific Computing, TU Braunschweig
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

if nargin<3 || isequal(I_u,I_f)
    m_f=size(I_f,1);
    F=spdiags(multiindex_factorial(I_f),0,m_f,m_f);
    f_j_beta=f_j_alpha*F;
else   
    m_f=size(I_f,1);
    m_u=size(I_u,1);
    n=size(f_j_alpha,1);
    f_j_beta=zeros( n, m_u );
    for i=1:m_f
        ind=multiindex_find(I_u, I_f(i,:));
        if ind
            f_j_beta(:,ind)=multiindex_factorial(I_f(i,:))*f_j_alpha(:,i);
        end
    end
end

% TODO: there is possibly a faster way to do this instead of using
% multiindex_find (or maybe speeding this up) by expressing the relation
% betweegn f_j_beta and f_j_alpha as a matrix multiply by a sparse matrix,
% this can be formed as Hadarmard product of logical matrices where each
% matrix if for one index k and entry ij being true means that index k of
% entry i in I_u (i.e. I_u(i,k)) and index k of entry j in I_f are the
% same. Multiplying this by a diagonal matrix that contains the factorials
% will do the rest of the trick.
