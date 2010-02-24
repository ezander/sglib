function klmodes_p41
% KLMODES_P41 Generates the plots of some KL-modes on an L-shaped domain from A. Keese's diss.
%   KLMODES_P41 Generates the plots of some KL-modes on an L-shaped domain
%   from A. Keese's diss. A. Keese's diss. (page 41). 
%
% Example (<a href="matlab:run_example klmodes_p41">run</a>)
%   klmodes_p41
%
% See also KL_SOLVE_EVP, LOAD_PDETOOL_GEOM, PLOT_FIELD, PLOT_FIELD_CONTOUR, PLOT_BOUNDARY

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


% properties for the covariance function and expansion
modes=[1,5,10,20];
mode_names={'First', '5-th', '10-th', '20-th' };
m=max(modes);
lc=0.5;
cov_func={@gaussian_covariance,{lc,1}};

% LShaped domain
[pos,els,G_N]=load_pdetool_geom( 'lshape', 1, false );
v_f=kl_solve_evp( covariance_matrix( pos, cov_func ), G_N, m, 'correct_var', true );
for j=1:m
    if mean(v_f(:,j))<0; v_f(:,j)=-v_f(:,j); end
end

set( gcf, 'Renderer', 'zbuffer' );
if ~strcmp( get( gcf, 'WindowStyle' ), 'docked' )
    set( gcf, 'Position', [0, 0, 900, 900])
end

for i=1:4
    subplot(2,2,i);
    u=v_f(:,modes(i));
    plot_field( pos, els, u, 'view', [220,25], 'colormap', 'cool', 'show_surf', true, 'shading', 'faceted' );
    plot_field_contour( pos, els, u, 'zpos', 'min' );
    plot_boundary( pos, els, 'color', 'k', 'zpos', min(u) );
    title(sprintf('%s KL-mode, L-shaped domain',mode_names{i}));
end
