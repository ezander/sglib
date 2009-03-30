%% Hermite polynomials (page 103).

addpath('../');
init_demos
clear

% properties for the covariance function and expansion

mode_names={'First', '5-th', '10-th', '20-th' };
pce_ind=[ 1, 1; 2, 2; 2, 3; 3, 3];
range=2;
numpoints=50;

% LShaped domain

%set( gcf, 'Position', [0, 0, 900, 900], 'Renderer', 'zbuffer' );

for i=1:4
    subplot(2,2,i);
    R=linspace(-range,range,numpoints);
    [X,Y]=meshgrid( R );

    %hermite_val_multi( [0,1,0,0,0,0], [0 0;1 0;0 1;2 0;1 1; 0 2],[x y])
   
    Z=hermite_val_multi( 1, pce_ind(i,:), [X(:), Y(:)]);
    Z=reshape( Z, size(X) );
    surf( X, Y, Z );
    title(sprintf('H_{(%d,%d)}(\\theta_1,\\theta_2)',pce_ind(i,1), pce_ind(i,2)));
end
