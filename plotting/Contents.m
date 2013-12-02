% PLOT
% ====
%
% This directory contains functions to support plotting of stochastic
% fields, distributions and the like. Further it helps keeping a consistent
% style in the generated plots (hopefully).
%
% Plotting
%   plot_boundary               - Plots the boundary of a triangular 2D mesh.
%   plot_field                  - Plots a field given on a triangular mesh.
%   plot_field_contour          - Plots a field given on a triangular mesh.
%   plot_pce_realizations_1d    -
%   spy2                        - Replacement for the SPY function.
%   spy_tensor                  -
%
% Support functions
%   logscale                    -
%   subtitle                    - Create a title over multiple subplots.
%   dock                        - Docks a figure window into the workspace.
%   undock                      - Undocks a figure window from the workspace.
%
% Unclassified functions
%   plot_kl_pce_realizations_1d -
%   animate_fields              - ANIMATE_FIELD Short description of animate_field.
%   change_tick_mode            - 
%   check_handle                - 
%   convert_eps_pdf             - Short description of convert_eps_pdf.
%   convert_png_eps             - Short description of convert_png_eps.
%   enlarge_legend              - Enlarge and moves the bounding box of a legend.
%   handle_debug                - #ok<*AGROW>
%   iteration_plot              - 
%   iteration_plot3             - 
%   legend_add                  - 
%   logaxis                     - Set axis type from linear to logarithmic or vice versa.
%   logscale                    - Safely creates log scaling for logarithmic plots.
%   multiplot                   - 
%   multiplot_init              - 
%   multiplot_legend            - Short description of multiplot_legend.
%   plot_boundary_conds         - Short description of plot_boundary_conds.
%   plot_field_complete         - 
%   plot_kl_pce_mean_var        - PLOT_PCE_MEAN_VAR Plot mean field and variance for a KL/PCE expansion.
%   plot_kl_pce_realizations_1d - Hint: The dimensions of the parameters must be such that 
%   plot_lines                  - Short description of plot_lines.
%   plot_linreg                 - Short description of plot_linreg.
%   plot_mesh                   - Plots a triangular 2D mesh.
%   plot_pce_realizations_1d    - 
%   psfrag_format               - 
%   psfrag_test                 - 
%   reparent_axes               - 
%   same_scaling                - 
%   save_eps                    - 
%   save_figure                 - Short description of save_figure.
%   save_latex                  - Short description of save_latex.
%   save_png                    - 
%   set_default_linestyles      - 
%   show_kl_pce_pdf_at          - SHOW_PCE_PDF_AT Short description of show_pce_pdf_at.
%   show_mesh_with_points       - Short description of show_mesh_with_points.
%   show_pce_pdf_at             - Short description of show_pce_pdf_at.
%   spy_tensor                  - 
%   write_tex_include           - 
%   write_tex_standalone        - 
%   ylim_extend                 - Extend the ylimits of an axis.

%   Elmar Zander
%   Copyright 2009, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.
