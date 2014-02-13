function [P_I,P_B]=boundary_projectors( bnd, n )
% BOUNDARY_PROJECTORS Projection matrices on the set of inner and boundary nodes.
%   [P_I,P_B]=BOUNDARY_PROJECTORS( BND, N ) return the projection matrices
%   P_I and P_B which projects from N nodes onto the internal nodes N\bnd
%   and boundary nodes given in the index array BND. E.g. for a linear FEM
%   problem with 20 nodes, N would be 20, and BND would be [1,20] if the
%   elements are in the usual order. A vector X defined on the whole ansatz
%   space can be projected by P_I*X on the space spanned only by the inner
%   nodes. If the matrix M acts on the whole space, P_I*M*P_I' acts only on
%   the inner nodes.
%
% Example (<a href="matlab:run_example boundary_projectors">run</a>)
%   % get K,f,g from some FEM code
%   % n contains the total number of nodes, and bnd the indices of the
%   % boundary nodes
%   [P_I,P_B]=boundary_projectors( bnd, n );
%
%   % method 1
%   I_B=P_B'*P_B;
%   I_I=P_I'*P_I;
%   Ks=I_I*K*I_I+I_B;         % modify operator
%   fs=I_I*(f-K*I_B*g)+I_B*g; % modify RHS
%   u=Ks\fs;                  % now solve with mod operator
%
%   % methode 2
%   fi=P_I*(f-K*I_B*gb);     % modified RHS for inner nodes
%   Ki=P_I*K*P_I';            % operator for inner nodes
%   ui=Ki\fi;                 % solve only on inner nodes
%   u=P_I'*ui+P_B'*gb;        % assemble inner and bnd node values
%
% See also APPLY_BOUNDARY_PROJECTORS

%   Elmar Zander
%   Copyright 2006, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

n_B=length(bnd);
n_I=n-n_B;

P_B=sparse( 1:n_B, bnd, ones(n_B,1), n_B, n );

int=ones(n,1);
int(bnd)=0;
int=find(int);
P_I=sparse( 1:n_I, int, ones(n_I,1), n_I, n );
