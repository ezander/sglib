function unittest_gpc_sobol_partial_vars
% UNITTEST_GPC_SOBOL_PARTIAL_VARS Test the GPC_SOBOL_PARTIAL_VARS function.
%
% Example (<a href="matlab:run_example unittest_gpc_sobol_partial_vars">run</a>)
%   unittest_gpc_sobol_partial_vars
%
% See also GPC_SOBOL_PARTIAL_VARS, MUNIT_RUN_TESTSUITE 

%   <author>
%   Copyright 2015, <institution>
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'gpc_sobol_partial_vars' );


%%
N = 7;
V_a = gpcbasis_create('HpL', 'p', 2);
a_i_alpha = rand(N, gpcbasis_size(V_a,1))

[part_vars, I_un, rat, ratpo]=gpc_sobol_partial_vars(V_a, a_i_alpha)
rat
ratpo
sum(part_vars)
sum(rat)
sum(ratpo)

