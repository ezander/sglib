function g_i_k=clear_non_boundary_values( g_i_k, bnd_nodes )
% CLEAR_NON_BOUNDARY_VALUES Clears all values that don't belong to the boundary.
%   G_I_K=CLEAR_NON_BOUNDARY_VALUES( G_I_K, BND_NODES ) clears all values
%   in G_I_K that are not in BND_NODES. 
%
% Note: 
%   This is mainly a hack for fields that specify random boundary
%   conditions but were generated on the whole domain e.g. by a KL
%   or Fourier expansion. 
%
% Example (<a href="matlab:run_example clear_non_boundary_values">run</a>)
%   [pos,els]=create_mesh_2d_rect(4);
%   freqs = (1:10)';
%   g_i_k = (sin(freqs*pos(1,:)).*cos(freqs*pos(2,:)))';
%   bnd = find_boundary(els, true);
%   clf; 
%   subplot(2,2,1); plot_field(pos, els, g_i_k(:,3));
%   subplot(2,2,3); plot_field(pos, els, g_i_k(:,9));
%   g_i_k=clear_non_boundary_values(g_i_k, bnd);
%   subplot(2,2,2); plot_field(pos, els, g_i_k(:,3));
%   subplot(2,2,4); plot_field(pos, els, g_i_k(:,9));
%
% See also FIND_BOUNDARY, PLOT_FIELD

%   Elmar Zander
%   Copyright 2013, Inst. of Scientif Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


ind=true(size(g_i_k,1),1);
ind(bnd_nodes)=false;
g_i_k(ind,:)=0;
