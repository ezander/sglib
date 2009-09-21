%% Smolyak grids 
% Shows some Smolyak grids in 2 and 3 dimensions for different quadrature
% rules.
%
% Back to the <./ directory index>

%% License
function show_smolyak_grids
%   Author: Elmar Zander
%   Copyright 2009, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


%% Smolyak grid for Clenshaw-Curtis rules (2D)

rule=@clenshaw_curtis_legendre_rule;
dim=2;

% Smolyak grid with 4 stages
[xd,wd]=smolyak_grid( dim, 4, rule );
plotnd(1, dim, xd);

% Smolyak grid with 5 stages
[xd,wd]=smolyak_grid( dim, 5, rule );
plotnd(2, dim, xd);

% Smolyak grid with 6 stages
[xd,wd]=smolyak_grid( dim, 6, rule );
plotnd(3, dim, xd);

% Smolyak grid with 7 stages
[xd,wd]=smolyak_grid( dim, 7, rule );
plotnd(4, dim, xd);

%% Smolyak grid for Clenshaw-Curtis rules (3D)

dim=3;

% Smolyak grid with 4 stages
[xd,wd]=smolyak_grid( dim, 4, rule );
plotnd(1, dim, xd);

% Smolyak grid with 5 stages
[xd,wd]=smolyak_grid( dim, 5, rule );
plotnd(2, dim, xd);

% Smolyak grid with 6 stages
[xd,wd]=smolyak_grid( dim, 6, rule );
plotnd(3, dim, xd);

% Smolyak grid with 7 stages
[xd,wd]=smolyak_grid( dim, 7, rule );
plotnd(4, dim, xd);

%% Smolyak grid for Gauss-Hermite rules (2D)

rule=@gauss_hermite_rule;
dim=2;

% Smolyak grid with 4 stages
[xd,wd]=smolyak_grid( dim, 4, rule );
plotnd(1, dim, xd);

% Smolyak grid with 5 stages
[xd,wd]=smolyak_grid( dim, 5, rule );
plotnd(2, dim, xd);

% Smolyak grid with 6 stages
[xd,wd]=smolyak_grid( dim, 6, rule );
plotnd(3, dim, xd);

% Smolyak grid with 7 stages
[xd,wd]=smolyak_grid( dim, 7, rule );
plotnd(4, dim, xd);

%% Smolyak grid for Gauss-Hermite rules (3D)

dim=3;

% Smolyak grid with 4 stages
[xd,wd]=smolyak_grid( dim, 4, rule );
plotnd(1, dim, xd);

% Smolyak grid with 5 stages
[xd,wd]=smolyak_grid( dim, 5, rule );
plotnd(2, dim, xd);

% Smolyak grid with 6 stages
[xd,wd]=smolyak_grid( dim, 6, rule );
plotnd(3, dim, xd);

% Smolyak grid with 7 stages
[xd,wd]=smolyak_grid( dim, 7, rule );
plotnd(4, dim, xd);

%% Smolyak grid for Gauss-Legendre rules (2D)

rule=@gauss_legendre_rule;
dim=2;

% Smolyak grid with 4 stages
[xd,wd]=smolyak_grid( dim, 4, rule );
plotnd(1, dim, xd);

% Smolyak grid with 5 stages
[xd,wd]=smolyak_grid( dim, 5, rule );
plotnd(2, dim, xd);

% Smolyak grid with 6 stages
[xd,wd]=smolyak_grid( dim, 6, rule );
plotnd(3, dim, xd);

% Smolyak grid with 7 stages
[xd,wd]=smolyak_grid( dim, 7, rule );
plotnd(4, dim, xd);

%% Smolyak grid for Gauss-Legendre rules (3D)

dim=3;

% Smolyak grid with 4 stages
[xd,wd]=smolyak_grid( dim, 4, rule );
plotnd(1, dim, xd);

% Smolyak grid with 5 stages
[xd,wd]=smolyak_grid( dim, 5, rule );
plotnd(2, dim, xd);

% Smolyak grid with 6 stages
[xd,wd]=smolyak_grid( dim, 6, rule );
plotnd(3, dim, xd);

% Smolyak grid with 7 stages
[xd,wd]=smolyak_grid( dim, 7, rule );
plotnd(4, dim, xd);

