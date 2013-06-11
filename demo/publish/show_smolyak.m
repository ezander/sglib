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

rule=@clenshaw_curtis_nested;
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

return
%% Smolyak grid for Clenshaw-Curtis rules (3D)

rule=@clenshaw_curtis_nested;
dim=3;

% Smolyak grid with 4 stages
[xd,wd]=smolyak_grid( 2, 4, rule );
subplot(2,2,1); plot(xd(1,:),xd(2,:),'*k');

% Smolyak grid with 5 stages
[xd,wd]=smolyak_grid( 2, 5, rule );
subplot(2,2,2); plot(xd(1,:),xd(2,:),'*k');

% Smolyak grid with 6 stages
[xd,wd]=smolyak_grid( 2, 6, rule );
subplot(2,2,3); plot(xd(1,:),xd(2,:),'*k');

% Smolyak grid with 7 stages
[xd,wd]=smolyak_grid( 2, 7, rule );
subplot(2,2,4); plot(xd(1,:),xd(2,:),'*k');



%%
return
rules={@gauss_hermite_rule, 'hermite';
      @gauss_legendre_rule, 'legendre';
      ; 'clenshaw-curtis' }

for rule={@gauss_hermite_rule, @gauss_legendre_rule, @clenshaw_curtis_nested}
      for i=1:4
        subplot(2,2,i);
        plot(xd(1,:),xd(2,:),'*k')
        subtitle( func2str( rule{1} ), 'interpreter', 'none' );
      end
      pause( 2 )
      for i=1:4
        [xd,wd]=smolyak_grid( 3, 3+i, rule );
        subplot(2,2,i);
        plot3(xd(1,:),xd(2,:),xd(3,:),'.k')
        subtitle( func2str( rule{1} ), 'interpreter', 'none' );
      end
      pause( 2 )
end
    

