function K=stiffness_matrix( elems, pos, k )
% STIFFNESS_MATRIX Assemble stiffness matrix for linear tri/tet elements.
%   K=STIFFNESS_MATRIX( ELEMS, POS, K ) computes the stiffness matrix for
%   triangular or tetrahedral elements specified in ELEMS with nodes
%   specified in POS. Linear nodal ansatz functions are used here. K on
%   input is a vector specifiying a coefficient field given at the nodes.

% TODO: implement for 3d.
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
    case 3
        error('not implemented yet');
    otherwise
        error('probably you have to pass your position vector transposed...');
end
        

for t=1:T
    nodes=elems(t,:);
    coords=pos(nodes,:);

    KT=elementStiffness( coords, k(nodes), xi, w );
   
    K(nodes,nodes)=K(nodes,nodes)+KT;
end


if 0
    % I think there's probably nothing to do here. Boundary conditions just
    % shouldn't be handled here. There should rather be some document on
    % how to do this properly and what to do with codes that included
    % boundary conditions in the stiffness matrix. 
    % The idea is that in a stochastic code you should never iterate on
    % matrices that still have equations for the boundary conditions,
    % because in stoch. setting that can make the operator as a whole
    % indefinite (even if it doesn't in the deterministic case). Thus the
    % stochastic code should only iterate on the inner nodes and omit that
    % artificial iteration stuff on the boundary nodes. The boundary stuff
    % should all go on the RHS and the iteration only proceed on the inner
    % nodes. Then positivity and symmetry of the operator is guaranteed.
    
    % Sketch of some sample code:
    %  say we have some wrapper for the superfem (tm) finite element
    %  analysis program and call their routine to multiply some vector x
    %  with the stiffness matrix by superfem_stiffness_apply( k, x ) and we
    %  know the boundary nodes are in bndidx. Then suppose we have the
    %  boundary conditions in g. Then we do 
    %     xg = superfem_stiffness_apply( k, g )
    %  In the solver we use something like that
    %     xn = superfem_stiffness_apply( k, x-xg )
    %  and use for our purposes of iteration only x(allidx\bndidx).
    %  Something like this at least, have to work it out in detail.
    
    % Old stuff: This was and ugly hack for imposing Dirichlet boundary
    % conditions, should be cleaned up somehow (but its really not trivial
    % to get the boundary conditons right in a stochastic setting)
    switch d
        case 1
            ind=find(pos==min(pos) | pos==max(pos));
            K(ind,:)=0;
            K(:,ind)=0;
            K(ind,ind)=eye(length(ind));
        case 2
            warning('BC''s for 2d not implemented yet');
        case 3
            warning('BC''s for 3d not implemented yet');
    end
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
    case 4 % d=3
        error( 'not yet implemented');
end

phi_xi=zeros(length(w),n_dof);
dphi_xi=zeros(length(w),d*n_dof);
for i=1:n_dof
    i2=d*(i-1)+(1:d);
    phi_xi(:,i)=phi{i}(xi);
    dphi_xi(:,i2)=dphi{i}(xi);
end
k_xi=phi_xi*k;

invJJ=inv(J*J');

KT=zeros(n_dof,n_dof);
for i=1:n_dof
    i2=d*(i-1)+(1:d);
    for j=1:n_dof
        j2=d*(j-1)+(1:d);
        KT(i,j)=sum(k_xi.*w.*sum((dphi_xi(:,i2)*invJJ).*dphi_xi(:,j2),2));
    end
end

KT=det(J)*KT;


% function y=N_P1_1d( xi )
% switch dof
%     case 1
%         y=1-xi
%     case 2
%         phi{1}=@(xi)(1-xi);
%         phi{2}=@(xi)(xi);
%         dphi{1}=@(xi)(-1*one);
%         dphi{2}=@(xi)( 1*one);
%         J=positions(2,:)-positions(1,:);
%     case 3 % d=2
%         phi{1}=@(xi)(1-xi(:,1)-xi(:,2));
%         phi{2}=@(xi)(xi(:,1));
%         phi{3}=@(xi)(xi(:,2));
%         dphi{1}=@(xi)( [-1*one,-1*one]  );
%         dphi{2}=@(xi)( [ 1*one, 0*one]  );
%         dphi{3}=@(xi)( [ 0*one, 1*one]  );

