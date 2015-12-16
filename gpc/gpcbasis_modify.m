function [V_un, Pr] = gpcbasis_modify(V_u, varargin)
% GPCBASIS_MODIFY Modifies a GPC basis.
%   V_UN = GPCBASIS_MODIFY(V_U, ARG1, ..., ARGN) creates a new GPC basis with the
%   same germ as V_U, where the optional parameters ARG1 to ARGN are passed
%   on to GPCBASIS_CREATE (see there for possible arguments/options).
%
%   [V_UN, PR] = GPCBASIS_MODIFY(V_U, ARG1, ..., ARGN) creates a new GPC
%   basis like in the first case, however, this time also a prolongation
%   operator PR is returned such that if U_I_ALPHA is a set of GPC
%   coefficients with respect to the basis V_U, then U_I_ALPHA*PR are the
%   GPC coefficients w.r.t. the basis V_UN (given that V_U is a subspace of
%   V_UN).
%
% Example (<a href="matlab:run_example gpcbasis_modify">run</a>)
%     % Create a gpc basis and some coefficients
%     V_u = gpcbasis_create('hlp', 'p', 2);
%     u_i_alpha = gpc_rand_coeffs(V_u, 3);
%     
%     % Now enlarge the basis and prolongate the coefficients
%     [V_un, Pr] = gpcbasis_modify(V_u, 'p', 4, 'ordering', 'random');
%     un_i_beta = u_i_alpha * Pr;
%     
%     % Evaluating at some sample points should give the same result
%     xi = gpcgerm_sample(V_u);
%     norm(gpc_evaluate(un_i_beta, V_un, xi)-gpc_evaluate(u_i_alpha, V_u, xi))
% 
% See also GPCBASIS_CREATE

%   Elmar Zander
%   Copyright 2015, Insititue of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

V_un = gpcbasis_create(V_u{1}, varargin{:});
V_un = [V_un, V_u{3:end}];

if nargout>=2
    Pr = multiindex_find(V_u{2}, V_un{2}, 'as_operators', true);
end
