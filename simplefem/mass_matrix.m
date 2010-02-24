function M=mass_matrix( pos, els )
% MASS_MATRIX Assemble the mass matrix.
%   M=MASS_MATRIX( ELS, POS ) computes the mass_matrix for the triangular
%   or tetrahedral elements specified in ELS with nodes specified in POS.
%   Linear nodal ansatz functions are used here.

N=size(pos,2);
T=size(els,2);

M=spalloc(N,N,T*3);

d=size(pos,1);
switch d
    case 1
        [xi,w]=gauss_legendre_rule(3);
        xi=(xi+1)/2;
        w=w/2;
    case 2
        [xi,w]=gauss_legendre_triangle_rule(3);
    otherwise
        error('simplefem:mass_matrix:param_error', 'Unsupported dimension: %d. Maybe you have to pass your position vector transposed?', d);
end


for t=1:T
    nodes=els(:,t);
    coords=pos(:,nodes);

    MT=elementMass( d, coords, xi, w );

    M(nodes,nodes)=M(nodes,nodes)+MT; %#ok<SPRIX>
end
M=0.5*(M+M');


function MT=elementMass( d, pos, xi, w )

switch d
    case 1
        phi{1}=@(xi)(1-xi);
        phi{2}=@(xi)(xi);
        J=pos(:,2)-pos(:,1);
    case 2
        phi{1}=@(xi)(1-xi(1,:)-xi(2,:));
        phi{2}=@(xi)(xi(1,:));
        phi{3}=@(xi)(xi(2,:));
        J=[pos(:,2)-pos(:,1), pos(:,3)-pos(:,1)];
end

if det(J)<=0
    warning( 'mass_matrix:neg_det', 'negative determinant detected' );
end

phi_xi=zeros(length(w),d+1);
for i=1:d+1
    phi_xi(:,i)=phi{i}(xi);
end

MT=abs(det(J))*phi_xi'*(w*ones(1,d+1).*phi_xi);


