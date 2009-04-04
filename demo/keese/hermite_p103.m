%% Hermite polynomials (page 103).

addpath('../');
init_demos
clear

% properties 

pce_ind=[ 1, 1; 2, 2; 2, 3; 3, 3];
range=2;
numpoints=50;

set( gcf, 'Renderer', 'zbuffer' );
if ~strcmp( get( gcf, 'WindowStyle' ), 'docked' )
    set( gcf, 'Position', [0, 0, 900, 900])
end
colormap( 'jet' );

for i=1:4
    subplot(2,2,i);
    R=linspace(-range,range,numpoints);
    [X,Y]=meshgrid( R );

    Z=hermite_val_multi( 1, pce_ind(i,:), [X(:), Y(:)]);
    Z=reshape( Z, size(X) );
    colormap('jet');
    shading('faceted');
    surf( X, Y, Z );
    title(sprintf('H_{(%d,%d)}(\\theta_1,\\theta_2)',pce_ind(i,1), pce_ind(i,2)));
end
