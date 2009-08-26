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
%
% See also

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

m_alpha_f=size(I_f,1);
m_beta_u=size(I_u,1);
n=size(f_j_alpha,1);
f_j_beta=zeros( n, m_beta_u );
for i=1:m_alpha_f
    ind=multiindex_find(I_u, I_f(i,:));
    if ind
        f_j_beta(:,ind)=multiindex_factorial(I_f(i,:))*f_j_alpha(:,i);
    end
end

