function plot_kl_pce_mean_var( pos, els, r_i_k, r_k_alpha, I_r )
% PLOT_PCE_MEAN_VAR Short description of plot_pce_mean_var.
%   PLOT_PCE_MEAN_VAR Long description of plot_pce_mean_var.
%
% Example (<a href="matlab:run_example plot_pce_mean_var">run</a>)
%
% See also

%   Elmar Zander
%   Copyright 2010, Inst. of Scientific Computing, TU Braunschweig
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

error( nargchk( 5, 5, nargin ) );

if isempty(r_i_k)
    [mu_r, var_r]=pce_moments( r_k_alpha, I_r );
else
    [mu_r, var_r]=kl_pce_moments( r_i_k, r_k_alpha, I_r );
end
options={'view', 3};
plot_field(pos, els, mu_r-sqrt(var_r), options{:} ); hold all;
plot_field(pos, els, mu_r, options{:} ); hold all;
plot_field(pos, els, mu_r+sqrt(var_r), options{:} );hold off;
set( findobj( gca, 'type', 'patch' ), 'EdgeColor', 'k' );
