function [Kn, fn] = apply_boundary_conditions_system( K, f, g, P_I, P_B )
% APPLY_BOUNDARY_CONDITIONS_SYSTEM Apply essential boundary conditions to a complete linear system.
%   [KN, FN] = APPLY_BOUNDARY_CONDITIONS_SYSTEM( K, F, G, P_I, P_B )
%   APPLY_BOUNDARY_CONDITIONS_SYSTEM Long description of apply_boundary_conditions_system.
%
% Options
%
% References
%
% Note 1: In general, but especially for linear operators in tensor product
%   form, it might be more efficient to the functions that reduce the
%   linear system to the inner nodes, and later adds the values at the
%   Dirichlet nodes to the solution.
%  
% Example (<a href="matlab:run_example apply_boundary_conditions_system">run</a>)
%
% See also

% modify that....
% APPLY_BOUNDARY_CONDITIONS_RHS Apply essential boundary conditions to right hand side.
%   FI=APPLY_BOUNDARY_CONDITIONS_RHS( K, F, G, P_I, P_B ) modifies the
%   right hand side F of a linear equation by projecting only to the inner
%   nodes and incorporating the effect of the essential boundary condition
%   in G. P_I is a matrix that project from the set of all nodes to
%   the set of all inner nodes, P_B project to the boundary nodes. Works on
%   normal (matrix) as on tensor product equations.
%
% Example (<a href="matlab:run_example apply_boundary_conditions_rhs">run</a>)
%   [pos,els,bnd]=create_mesh_1d( 0, 2, 5 );
%   K=stiffness_matrix( pos, els, ones(size(pos)) );
%   f=sin(pi*pos);
%   g=2+pos;
%   [P_I,P_B]=boundary_projectors( bnd, size(pos,2) );
%   fi=apply_boundary_conditions_rhs( K, f, g, P_I, P_B );
%   fprintf( '%4s  %4s\n', 'f', 'fi', '====', '====' )
%   fprintf( '%4d  %4d\n', round([ f, [nan; fi; nan ]])' )
%
% See also BOUNDARY_PROJECTORS, APPLY_BOUNDARY_CONDITIONS_OPERATOR

%   Elmar Zander
%   Copyright 2014, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


I_I = P_I' * P_I;
I_B = P_B' * P_B;

if isnumeric(K)
    M = get_stoch_size(P_I, K, [], []);
    I_S=speye(M);
    I_I_ex=revkron(I_I, I_S);
    I_B_ex=revkron(I_B, I_S);
else
    r=size(K,2);
    I_S=cell(1,r-1);
    for i=1:r-1
        I_S{1,i}=speye(size(K{1,i+1},1));
    end
    I_I_ex=[{I_I}, I_S];
    I_B_ex=[{I_B}, I_S];
end

% this computes the following:
%   fi=P_I*(f-K*P_B'*P_B*g);
% to accomodate for tensor product operators the projection operators are
% extended like P_I => P_I \otimes I_S where I_S is the identity on the
% "second" space (usually the stochastic one).


% Kn = I_I * K * I_I + I_B
% fn = I_I * f + I_B * g - I_I * K * I_B * g

Kn = operator_compose( I_I_ex, operator_compose( K, I_I_ex ) );
Kn = operator_add( Kn, I_B_ex );

fn=operator_apply( I_I_ex, f );
gb=operator_apply( I_B_ex, g );
fn=tensor_add( fn, gb );
gbf=operator_apply( I_I_ex, operator_apply(K, gb) );
fn=tensor_add( fn, gbf, -1 );
