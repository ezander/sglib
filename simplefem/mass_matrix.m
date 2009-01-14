function M=mass_matrix( elems, pos )
% MASS_MATRIX Assemble the mass matrix.
%   M=MASS_MATRIX( ELEMS, POS ) computes the mass_matrix for the triangular
%   or tetrahedral elements specified in ELEMS with nodes specified in POS.
%   Linear nodal ansatz functions are used here. 

% TODO: implement for 3d

N=size(pos,1);
T=size(elems,1);

M=spalloc(N,N,T*3);

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

    MT=elementMass( coords, xi, w );
   
    M(nodes,nodes)=M(nodes,nodes)+MT;
end
M=0.5*(M+M');

function MT=elementMass( positions, xi, w )
n_dof=size( positions, 2 )+1;
switch n_dof
    case 2 % d=1
        phi{1}=@(xi)(1-xi);
        phi{2}=@(xi)(xi);
        J=positions(2,:)-positions(1,:);
    case 3 % d=2
        phi{1}=@(xi)(1-xi(:,1)-xi(:,2));
        phi{2}=@(xi)(xi(:,1));
        phi{3}=@(xi)(xi(:,2));
        J=[positions(2,:)-positions(1,:)
            positions(3,:)-positions(1,:)];
    case 4 % d=3
        error( 'not yet implemented');
end
% TODO: what is the best thing to do if det J<0??
if det(J)<=0
    warning( 'mass_matrix:neg_det', 'negative determinant detected' );
end 

phi_xi=zeros(length(w),n_dof);
for i=1:n_dof
    phi_xi(:,i)=phi{i}(xi);
end

MT=abs(det(J))*phi_xi'*(w*ones(1,n_dof).*phi_xi);


