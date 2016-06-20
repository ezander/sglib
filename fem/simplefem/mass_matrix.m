function M=mass_matrix( pos, els )
% MASS_MATRIX Assemble the mass matrix.
%   M=MASS_MATRIX( POS, ELS ) computes the mass_matrix for the Lagrange P1
%   elements (i.e. linear nodal trial functions) specified in ELS with
%   nodes specified in POS. Currently only 1D and 2D meshes are supported
%   (and probably will be in the future).
%
% Note:
%   This function is not vectorised and pretty slow for larger meshes.
%   Please use a decent FEM code for larger meshes. This is just a toy
%   implementation for testing out stochastic methods.
%
% Example (<a href="matlab:run_example mass_matrix">run</a>)
%   % Print standard 1D mass matrix on console
%   [pos, els] = create_mesh_1D(0, 1, 5);
%   M = rats(full(mass_matrix(pos, els))*4)
%   % Show sparsity pattern of 2D mass matrix
%   [pos, els] = create_mesh_2d_rect(3);
%   M = mass_matrix(pos, els);
%   spy(M);
%
% See also STIFFNESS_MATRIX

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

M=mass_matrix_new(pos, els);

function M=mass_matrix_new(pos, els)
d = size(pos,1);
N = size(pos, 2);
x = reshape(pos(:,els), [d, size(els)]);
v = binfun(@minus, x(:,2:end,:), x(:,1,:));
switch(d)
    case 1
        J = v;
    case 2
        J = v(1,1,:).*v(2,2,:) - v(1,2,:).*v(2,1,:);
    otherwise
        error('simplefem:mass_matrix:param_error', 'Unsupported dimension: %d. Maybe you have to pass your position vector transposed?', d);
end
J=J(:);

n = size(els,1);
[i1,i2]=meshgrid(1:n,1:n);

j1=els(i1,:); 
j2=els(i2,:); 
v = repmat(J', n*n, 1) .* (1+(j1==j2)) / factorial(d+2);
M = sparse(j1, j2, v, N, N);

function M=mass_matrix_old(pos, els)
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
        error('simplefem:mass_matrix:param_error', 'Unsupported dimension: %d. Maybe you have to pass your position vector transposed?', d);
end

% Compute element mass matrices for each element and assemble
N=size(pos,2);
T=size(els,2);
M=spalloc(N,N,T*3);
for t=1:T
    nodes=els(:,t);
    coords=pos(:,nodes);

    Mt=element_mass( d, coords, xi, w );
    M(nodes,nodes)=M(nodes,nodes)+Mt; %#ok<SPRIX>
end

% Symmetrise the mass matrix
M=0.5*(M+M');


function MT=element_mass( d, pos, xi, w )
% ELEMENT_MASS Compute element mass matrix.

switch d
    case 1
        phi{1}=1-xi;
        phi{2}=xi;
        J=pos(:,2)-pos(:,1);
    case 2
        phi{1}=1-xi(1,:)-xi(2,:);
        phi{2}=xi(1,:);
        phi{3}=xi(2,:);
        J=[pos(:,2)-pos(:,1), pos(:,3)-pos(:,1)];
end

if det(J)<=0
    warning( 'mass_matrix:neg_det', 'negative determinant detected' );
end

phi_xi=zeros(length(w),d+1);
for i=1:d+1
    phi_xi(:,i)=phi{i};
end

MT=abs(det(J))*phi_xi'*(w*ones(1,d+1).*phi_xi);
