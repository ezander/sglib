function K=stiffness_matrix( pos, els, k )
% STIFFNESS_MATRIX Assemble stiffness matrix for P1 elements.
%   K=STIFFNESS_MATRIX( POS, ELS, K ) computes the stiffness matrix for
%   Lagrange P1 elements specified in ELS with nodes specified in POS.
%   K on input is a vector specifiying a coefficient field given at the nodes.
%
% Note:
%   This function is not vectorised and pretty slow for larger meshes.
%   Please use a decent FEM code for larger meshes. This is just a toy
%   implementation for testing out stochastic methods.
%
% Example (<a href="matlab:run_example stiffness_matrix">run</a>)
%   % Print standard 1D stiffness matrix on console
%   [pos, els] = create_mesh_1D(0, 1, 5);
%   K = full(stiffness_matrix(pos, els, 0.25*ones(size(pos,2),1)))
%   % Show sparsity pattern of 2D stiffness matrix
%   [pos, els] = create_mesh_2D_rect(3);
%   K = stiffness_matrix(pos, els, ones(size(pos,2),1));
%   spy(K);
%
% See also MASS_MATRIX

%   Elmar Zander
%   Copyright 2013, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


% TODO: check dimension of k
if nargin<3 || isempty(k)
    k=ones(1,size(pos,2))'; % make dual
end


% Determine the Gauss-Legendre rule to use for integration
d=size(pos,1);
switch d
    case 1
        [xi,w]=gauss_legendre_rule(3);
        xi=(xi+1)/2;
        w=w/2;
    case 2
        [xi,w]=gauss_legendre_triangle_rule(3);
    otherwise
        error('simplefem:stiffness_matrix:param_error', 'Unsupported dimension: %d. Maybe you have to pass your position vector transposed?', d);
end

% Compute element stiffness matrices for each element and assemble
N=size(pos,2);
T=size(els,2);
K=spalloc(N,N,T*3);
for t=1:T
    nodes=els(:,t);
    coords=pos(:,nodes);

    Kt=element_stiffness( d, coords, k(nodes), xi, w );
    K(nodes,nodes)=K(nodes,nodes)+Kt; %#ok<SPRIX>
end


function KT=element_stiffness( d, pos, k, xi, w )
% ELEMENT_STIFFNESS Compute the element stiffness matrix.
n_dof=d+1;
switch d
    case 1
        phi{1}=1-xi;
        phi{2}=xi;
        dphi{1}=-ones(size(xi,1),1);
        dphi{2}= ones(size(xi,1),1);
        J=pos(:,2)-pos(:,1);
    case 2
        phi{1}=1-xi(1,:)-xi(2,:);
        phi{2}=xi(1,:);
        phi{3}=xi(2,:);
        dphi{1}=[-1;-1]*ones(1,size(xi,2),1);
        dphi{2}=[ 1; 0]*ones(1,size(xi,2),1);
        dphi{3}=[ 0; 1]*ones(1,size(xi,2),1);
        J=[pos(:,2)-pos(:,1), pos(:,3)-pos(:,1)];
end

phi_xi=zeros(length(w),n_dof);
dphi_xi=zeros(length(w),d*n_dof);
for i=1:n_dof
    i2=d*(i-1)+(1:d);
    phi_xi(:,i)=phi{i}';
    dphi_xi(:,i2)=dphi{i}';
end
k_xi=phi_xi*k;

invJJ=inv(J'*J); %#ok<*MINV>

KT=zeros(n_dof,n_dof);
for i=1:n_dof
    i2=d*(i-1)+(1:d);
    for j=1:n_dof
        j2=d*(j-1)+(1:d);
        KT(i,j)=sum(k_xi.*w.*sum((dphi_xi(:,i2)*invJJ).*dphi_xi(:,j2),2)); 
    end
end
KT=det(J)*KT;
