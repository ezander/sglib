function K=stiffness_matrix( elems, pos, k )
% STIFFNESS_MATRIX Assemble stiffness matrix for linear tri/tet elements.
%   K=STIFFNESS_MATRIX( ELEMS, POS, K ) computes the stiffness matrix for
%   triangular or tetrahedral elements specified in ELEMS with nodes
%   specified in POS. Linear nodal ansatz functions are used here. K on
%   input is a vector specifiying a coefficient field given at the nodes.

% TODO: check dimension of k
if nargin<3 || isempty(k)
    k=ones(size(pos,1),1);
end

N=size(pos,1);
T=size(elems,1);

K=spalloc(N,N,T*3);

d=size(pos,2);
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
    nodes=elems(t,:);
    coords=pos(nodes,:);

    KT=elementStiffness( coords, k(nodes), xi, w );

    K(nodes,nodes)=K(nodes,nodes)+KT; %#ok<SPRIX>
end


function KT=elementStiffness( positions, k, xi, w )
n_dof=size( positions, 2 )+1;
d=size(xi,2);
switch n_dof
    case 2 % d=1
        phi{1}=@(xi)(1-xi);
        phi{2}=@(xi)(xi);
        dphi{1}=@(xi)(-1*ones(size(xi,1),1));
        dphi{2}=@(xi)( 1*ones(size(xi,1),1));
        J=positions(2,:)-positions(1,:);
    case 3 % d=2
        phi{1}=@(xi)(1-xi(:,1)-xi(:,2));
        phi{2}=@(xi)(xi(:,1));
        phi{3}=@(xi)(xi(:,2));
        dphi{1}=@(xi)( ones(size(xi,1),1)*[-1,-1] );
        dphi{2}=@(xi)( ones(size(xi,1),1)*[ 1, 0] );
        dphi{3}=@(xi)( ones(size(xi,1),1)*[ 0, 1] );
        J=[positions(2,:)-positions(1,:)
            positions(3,:)-positions(1,:)];
end

phi_xi=zeros(length(w),n_dof);
dphi_xi=zeros(length(w),d*n_dof);
for i=1:n_dof
    i2=d*(i-1)+(1:d);
    phi_xi(:,i)=phi{i}(xi);
    dphi_xi(:,i2)=dphi{i}(xi);
end
k_xi=phi_xi*k;

invJJ=inv(J*J'); %#ok<*MINV>

KT=zeros(n_dof,n_dof);
for i=1:n_dof
    i2=d*(i-1)+(1:d);
    for j=1:n_dof
        j2=d*(j-1)+(1:d);
        KT(i,j)=sum(k_xi.*w.*sum((dphi_xi(:,i2)*invJJ).*dphi_xi(:,j2),2)); 
    end
end

KT=det(J)*KT;
