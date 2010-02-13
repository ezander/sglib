function Ki=apply_boundary_conditions_operator( K, P_I )
% APPLY_BOUNDARY_CONDITIONS_OPERATOR Apply essential boundary conditions to operator.
%   KI=APPLY_BOUNDARY_CONDITIONS_OPERATOR( K, P_I ) modifies the
%   linear operator (maybe matrix or tensor operator) to only act on the
%   inner nodes. P_I is a matrix that project from the set of all nodes to
%   the set of all inner nodes.
%
% Example (<a href="matlab:run_example apply_boundary_conditions_operator">run</a>)
%   [els,pos,bnd]=create_mesh_1d( 5, 0, 2 );
%   K=stiffness_matrix( els, pos, ones(size(pos)) );
%   fprintf( 'cond. number of K:  %g\n', condest(K) );
%   [P_I,P_B]=boundary_projectors( bnd, size(pos,1) );
%   Ki=apply_boundary_conditions_operator( K, P_I );
%   fprintf( 'cond. number of Ki: %g\n', condest(Ki) );
%
% See also BOUNDARY_PROJECTORS, APPLY_BOUNDARY_CONDITIONS_RHS,
%   APPLY_BOUNDARY_CONDITIONS_SOLUTION

%   Elmar Zander
%   Copyright 2009, Institute of Scientific Computing, TU Braunschweig.
%   $Id$
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

if ~iscell(K) || size(K,2)<=2
    N=size(P_I,2);
    NM=tensor_operator_size(K);
    M=NM(1)/N;
    I_S={speye(M)};
else
    r=size(K,2);
    I_S=cell(1,r-1);
    for i=1:r-1
        I_S{1,i}=speye(size(K{1,i+1},1));
    end
end
Ki=tensor_operator_compose( [{P_I}, I_S], K );
Ki=tensor_operator_compose( Ki, [{P_I'}, I_S] );
