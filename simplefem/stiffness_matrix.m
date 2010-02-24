function K=stiffness_matrix( pos, els, k )
% STIFFNESS_MATRIX Assemble stiffness matrix for linear tri/tet elements.
%   K=STIFFNESS_MATRIX( POS, ELS, K ) computes the stiffness matrix for
%   triangular or tetrahedral elements specified in ELS with nodes
%   specified in POS. Linear nodal ansatz functions are used here. K on
%   input is a vector specifiying a coefficient field given at the nodes.

% TODO: check dimension of k
if nargin<3 || isempty(k)
    k=ones(1,size(pos,2))'; % make dual
end

N=size(pos,2);
T=size(els,2);

K=spalloc(N,N,T*3);

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


for t=1:T
    nodes=els(:,t);
    coords=pos(:,nodes);

    KT=elementStiffness( d, coords, k(nodes), xi, w );

    K(nodes,nodes)=K(nodes,nodes)+KT; %#ok<SPRIX>
end


function KT=elementStiffness( d, pos, k, xi, w )
n_dof=d+1;
switch d
    case 1
        phi{1}=@(xi)(1-xi);
        phi{2}=@(xi)(xi);
        dphi{1}=@(xi)(-1*ones(size(xi,1),1));
        dphi{2}=@(xi)( 1*ones(size(xi,1),1));
        J=pos(:,2)-pos(:,1);
    case 2
        phi{1}=@(xi)(1-xi(1,:)-xi(2,:));
        phi{2}=@(xi)(xi(1,:));
        phi{3}=@(xi)(xi(2,:));
        dphi{1}=@(xi)( [-1;-1]*ones(1,size(xi,2),1) );
        dphi{2}=@(xi)( [ 1; 0]*ones(1,size(xi,2),1) );
        dphi{3}=@(xi)( [ 0; 1]*ones(1,size(xi,2),1) );
        J=[pos(:,2)-pos(:,1), pos(:,3)-pos(:,1)];
end

phi_xi=zeros(length(w),n_dof);
dphi_xi=zeros(length(w),d*n_dof);
for i=1:n_dof
    i2=d*(i-1)+(1:d);
    phi_xi(:,i)=phi{i}(xi)';
    dphi_xi(:,i2)=dphi{i}(xi)';
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
