function Ki=apply_boundary_conditions_operator( K, P_I )
% APPLY_BOUNDARY_CONDITIONS_OPERATOR Apply essential boundary conditions to operator.
%   KI=APPLY_BOUNDARY_CONDITIONS_OPERATOR( K, P_I ) modifies the
%   linear operator (maybe matrix or tensor operator) to only act on the
%   inner nodes. P_I is a matrix that project from the set of all nodes to
%   the set of all inner nodes.
%
% Example (<a href="matlab:run_example apply_boundary_conditions_operator">run</a>)
%   [pos,els,bnd]=create_mesh_1d( 0, 2, 5 );
%   K=stiffness_matrix( pos, els, ones(size(pos)) );
%   fprintf( 'cond. number of K:  %g\n', condest(K) );
%   [P_I,P_B]=boundary_projectors( bnd, size(pos,2) );
%   Ki=apply_boundary_conditions_operator( K, P_I );
%   fprintf( 'cond. number of Ki: %g\n', condest(Ki) );
%
% See also BOUNDARY_PROJECTORS, APPLY_BOUNDARY_CONDITIONS_RHS,
%   APPLY_BOUNDARY_CONDITIONS_SOLUTION

%   Elmar Zander
%   Copyright 2009, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

if isnumeric(K)
    N=size(P_I,2);
    NM=size(K,1);
    M=NM(1)/N;
    I_S=speye(M);
    P=revkron(P_I,I_S);
    PT=revkron(P_I',I_S);
elseif is_tensor_operator(K) % tensor operator
    d=tensor_operator_size( K, false );
    n=size(d,1);
    I_S=cell(1,n-1);
    for i=1:n-1
        I_S{1,i}=speye(d(i+1,1));
    end
    P=[{P_I}, I_S];
    PT=[{P_I'}, I_S];
else
    error( 'sglib:unknown_operator_type', 'Unknown or unsupported operator type' );
end

Ki=operator_compose( P, operator_compose( K, PT ) );

