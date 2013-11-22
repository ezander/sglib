function u=kl_pce_solve_system( k_i_k, k_k_alpha, I_k, f_i_k, f_k_alpha, I_f, g_i_k, g_k_alpha, I_g, stiffness_func, P_I, P_B, xi )
% KL_PCE_SOLVE_SYSTEM Short description of kl_pce_solve_system.
%   KL_PCE_SOLVE_SYSTEM Long description of kl_pce_solve_system.
%
% Example (<a href="matlab:run_example kl_pce_solve_system">run</a>)
%
% See also

%   Elmar Zander
%   Copyright 2011, Inst. of Scientific Computing
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

if size( xi, 2 )>1
    error( 'not possible' );
end

[k]=kl_pce_field_realization( k_i_k, k_k_alpha, I_k, xi );
[f]=kl_pce_field_realization( f_i_k, f_k_alpha, I_f, xi );
[g]=kl_pce_field_realization( g_i_k, g_k_alpha, I_g, xi );

K=funcall( stiffness_func, k );
Ki=apply_boundary_conditions_operator( K, P_I );
fi=apply_boundary_conditions_rhs( K, f, g, P_I, P_B );
ui=Ki\fi;
u=apply_boundary_conditions_solution( ui, g, P_I, P_B );
