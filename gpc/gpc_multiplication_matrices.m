function A_i = gpc_multiplication_matrices(a_i_alpha, V_a, V_u, V_v, varargin)
% GPC_MULTIPLICATION_MATRICES Short description of gpc_multiplication_matrices.
%   GPC_MULTIPLICATION_MATRICES Long description of gpc_multiplication_matrices.
%
% Options
%
% References
%
% Notes
%
% Example (<a href="matlab:run_example gpc_multiplication_matrices">run</a>)
%
% See also

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

if ~exist('V_v', 'var') || isempty(V_v)
    V_v = V_u;
elseif ischar(V_v)
    varargin = {V_v, varargin{:}};
    V_v = V_u;
end
options = varargin2options(varargin, mfilename);
[normalise, options]=get_option(options, 'normalise', true);
check_unsupported_options(options);

M_a = gpcbasis_size(V_a, 1);
M_u = gpcbasis_size(V_u, 1);
M_v = gpcbasis_size(V_v, 1);

M = gpcbasis_triples(V_a, V_u, V_v);
if normalise
    inv_norm = 1./gpcbasis_norm(V_v, 'sqrt', false);
    inv_norm = reshape(inv_norm, 1, 1, []);
    M = binfun(@times, M, inv_norm);
end
M = reshape(M, M_a, []);

A = a_i_alpha * M;
R = size(a_i_alpha,1);
A_i = cell(1,R);
for i=1:R
    A_i{i} = reshape(A(i,:), M_u, M_v);
end
