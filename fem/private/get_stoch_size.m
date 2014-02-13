function [M,N]=get_stoch_size(P_I, K, u_I, u)
% GET_STOCH_SIZE Get the size of the stochastic basis from sizes of other quantities.
%   [M,N]=GET_STOCH_SIZE(P_I, K, U_I, U) gets the size of the stochastic
%   basis M from the projector to the spatial inner nodes P_I and one of K
%   (the spatial/stochastic stiffness matrix), U_I (a spatial/stochastic
%   vector or matrix on the inner nodes) or U (a spatial/stochastic
%   vector or matrix on the all nodes).
%   This functions is used internally for the apply_boundary_conditions
%   functions.

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

if ~isempty(K) + ~isempty(u) + ~isempty(u_I) ~= 1
    error('sglib:apply_boundary_conditions', 'Exactly one of K, u or ui must be non-empty!');
end

if ~isempty(K)
    N=size(P_I,2);
    NM=size(K, 1);
elseif ~isempty(u)
    N=size(P_I,2);
    NM=numel(u);
else
    N=size(P_I,1);
    NM=numel(u_I);
end
M=NM/N;

if round(M)~=M
    error('sglib:apply_boundary_conditions', 'Can''t determine size of stochastic basis. Not an integer multiple.');
end
