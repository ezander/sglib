function plot_response_surface(V_u, u_alpha, N, varargin)
% PLOT_RESPONSE_SURFACE Short description of plot_response_surface.
%   PLOT_RESPONSE_SURFACE Long description of plot_response_surface.
%
% Options
%
% References
%
% Notes
%
% Example (<a href="matlab:run_example plot_response_surface">run</a>)
%
% See also

%   Elmar Zander
%   Copyright 2013, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

options=varargin2options(varargin);
[delta,options]=get_option(options, 'delta', 0.02);
[alpha_val,options]=get_option(options, 'alpha', 'auto');
[pdf_plane,options]=get_option(options, 'pdf_plane', 'auto');
[surf_color,options]=get_option(options, 'surf_color', 'height');
check_unsupported_options(options, mfilename);

% check size(u_alpha,1)==1

if isequal(alpha_val, 'auto')
    if isequal(pdf_plane, 'none')
        alpha_val=1.0;
    else
        alpha_val=0.6;
    end
end

% compute the grid of parameter values
[UX, UY] = meshgrid(linspace(delta, 1-delta, N));
xi = gpc_sample(V_u, N*N, 'rand_func', @(m,n)([UX(:),UY(:)]));

% compute gpc values
u = gpc_evaluate(u_alpha, V_u, xi);
c_u = normalize(u);

% compute gpc pdf
p = gpc_pdf(V_u, xi);
c_p = normalize(p);

% plot the response
switch surf_color
    case 'height'
        c = c_u;
    case 'pdf'
        c = c_p;
    otherwise
        error('sglib:plot', 'Unknown surf_color value "%s"', surf_color);
end

reshape_surf(N, N, xi(1,:), xi(2,:), u, c)
shading('interp');
if alpha_val<1
    alpha(alpha_val);
end


% plot pdf plane if necessary
if ~isequal(pdf_plane, 'none')
    % determine pdf plane 
    if isequal(pdf_plane, 'auto')
        l = min(u) - 0.2 * (max(u)-min(u));
    else
        l = pdf_plane;
    end
    
    % plot pdf
    hold on;
    reshape_surf(N, N, xi(1,:), xi(2,:), repmat(l, size(p)), c_p)
    hold off;
    shading('interp');
end

function reshape_surf(Nx, Ny, x, y, z, c, varargin)
N=[Nx, Ny];
surf( reshape(x,N), reshape(y,N), reshape(z,N), reshape(c,N), varargin{:});

function xn = normalize(x)
x1=min(x(:));
x2=max(x(:));
if (x2-x1) <= 1e-6 * (x1+x2)
    xn = repmat(0.5, size(x));
else
    xn=(x-x1)/(x2-x1);
end
