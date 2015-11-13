function plot_response_surface(u_i_alpha, V_u, varargin)
% PLOT_RESPONSE_SURFACE Short description of plot_response_surface.
%   PLOT_RESPONSE_SURFACE Long description of plot_response_surface.
%
% Options
%   delta: double {0.02}
%     Plot range is determined by the inverse cdf from [delta, 1-delta].
%     Some better heuristics needs to be implemented, probably.
%   N: integer {20}
%     Number of divisions in x and y direction.
%   alpha: double {'auto'}
%     Value for transparency, 0 means fully transparent, 1 means opaque.
%   pdf_plane: double {'auto'}
%     Z-position of the pdf plane, showing the joint pdf of the parameters.
%   surf_color: {'height'}, 'pdf'
%     Coloring scheme for the response surfaces. Either the height of the
%     response surface itself, or the joint pdf of the parameters.
%
% Example 1 (<a href="matlab:run_example plot_response_surface 1">run</a>)
%   V_u = gpcbasis_create('U', 'm', 2, 'p', 3);
%   u_i_alpha = rand(3, gpcbasis_size(V_u, 1));
%   plot_response_surface(u_i_alpha, V_u);
%
% Example 2 (<a href="matlab:run_example plot_response_surface 2">run</a>)
%   V_u = gpcbasis_create('U', 'm', 2, 'p', 4);
%   u_i_alpha = randn(2, gpcbasis_size(V_u, 1));
%   plot_response_surface(u_i_alpha, V_u, 'surf_color', 'pdf', 'pdf_plane', 'none');
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
[N,options]=get_option(options, 'N', 20);
[alpha_val,options]=get_option(options, 'alpha', 'auto');
[pdf_plane,options]=get_option(options, 'pdf_plane', 'auto');
[surf_color,options]=get_option(options, 'surf_color', 'height');
check_unsupported_options(options, mfilename);

Nu=size(u_i_alpha,1);

% determine alpha value for transparency
if isequal(alpha_val, 'auto')
    if isequal(pdf_plane, 'none') && Nu==1
        alpha_val=1.0;
    else
        alpha_val=0.6;
    end
end

% compute the grid of parameter values
[UX, UY] = meshgrid(linspace(delta, 1-delta, N));
xi = gpcgerm_sample(V_u, N*N, 'rand_func', @(m,n)([UX(:),UY(:)]));

% compute gpc values
u = gpc_evaluate(u_i_alpha, V_u, xi);
c_u = normalize(u);

% compute gpc pdf
p = gpcgerm_pdf(V_u, xi);
c_p = normalize(p);

% plot the response
switch surf_color
    case 'height'
        c = c_u;
    case 'pdf'
        c = repmat(c_p, Nu, 1);
    otherwise
        error('sglib:plot', 'Unknown surf_color value "%s"', surf_color);
end

% remember whether hold was on
s = ishold;

% plot the reponse surfaces
for i=1:Nu
    reshape_surf(N, N, xi(1,:), xi(2,:), u(i,:), c(i,:));
    shading('interp');
    if alpha_val<1
        alpha(alpha_val);
    end
    hold on;
end

% plot pdf plane if necessary
if ~isequal(pdf_plane, 'none')
    % determine z-location of pdf plane 
    if isequal(pdf_plane, 'auto')
        l = min(u(:)) - 0.2 * (max(u(:))-min(u(:)));
    else
        l = pdf_plane;
    end
    
    % plot the pdf
    hold on;
    reshape_surf(N, N, xi(1,:), xi(2,:), repmat(l, size(p)), c_p)
    shading('interp');
end

% is hold was on, then reset
if ~s
    hold off;
end

function reshape_surf(Nx, Ny, x, y, z, c, varargin)
% RESHAPE_SURF Plot a surface by first reshaping the vectors into matrices
N=[Nx, Ny];
surf( reshape(x,N), reshape(y,N), reshape(z,N), reshape(c,N), varargin{:});

function xn = normalize(x)
% NORMALIZE Normalise a vector or matrix along the second dim to [0,1]
x1=min(x,[],2);
x2=max(x,[],2);

xn = repmat(0.5, size(x));
ind = (x2-x1) > 1e-6 * (x1+x2);
if any(ind)
    xn(ind,:)=binfun(@rdivide, binfun(@minus, x(ind,:), x1(ind)), x2(ind)-x1(ind));
end
