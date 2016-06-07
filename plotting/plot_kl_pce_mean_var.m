function plot_kl_pce_mean_var( pos, els, r_i_k, r_k_alpha, I_r, varargin )
% PLOT_PCE_MEAN_VAR Plot mean field and variance for a KL/PCE expansion.
%   PLOT_KL_PCE_MEAN_VAR( POS, ELS, R_I_K, R_K_ALPHA, I_R, OPTIONS ) plots
%   the mean and mean+-variance for the field specified in the parameters.
%   Works currently only for triangular 2D meshes.
%
% Options:
%   show_mesh: {true}, false
%     Determines wether the mesh lines are overlayed over the surface.
%   pass_on: {}
%     Further options that are passed to PLOT_FIELD.
%
% Example (<a href="matlab:run_example plot_pce_mean_var">run</a>)
%
% See also PLOT_FIELD, PLOT_BOUNDARY, PLOT_MESH

%   Elmar Zander
%   Copyright 2010, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

check_num_args(nargin, 5, inf, mfilename);

options=varargin2options( varargin );
[show_mesh,options]=get_option( options, 'show_mesh', true );
[pass_on,options]=get_option( options, 'pass_on', {} );
check_unsupported_options( options, mfilename );

if isempty(r_i_k)
    [mu_r, var_r]=pce_moments( r_k_alpha, I_r );
else
    [mu_r, var_r]=kl_pce_moments( r_i_k, r_k_alpha, I_r );
end
options={'view', 3, 'show_mesh', show_mesh, pass_on{:}};

holda=get(gca,'nextplot');
holdf=get(gcf,'nextplot');

plot_field(pos, els, mu_r-sqrt(var_r), options{:} ); hold all;
plot_field(pos, els, mu_r, options{:} ); hold all;
plot_field(pos, els, mu_r+sqrt(var_r), options{:} );
if show_mesh
    set( findobj( gca, 'type', 'patch' ), 'EdgeColor', 'k' );
end

set(gca,'nextplot',holda);
set(gcf,'nextplot',holdf);
