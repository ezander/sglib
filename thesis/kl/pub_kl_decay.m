%% Decay of KL eigenfunctions
% Elmar Zander, March 2010


%% Preliminary: Load geometry and model data
clear; clf;
model_large
geom='scatter'
num_refine=0;

define_geometry

[pos,els]=refine_mesh(pos,els);
plot_mesh( pos, els, 'color', 'b' );
plot_boundary( pos, els, 'color', 'r' );
axis equal
axis tight

%% 1.1  Gaussian covariance
% 

cov_func={@gaussian_covariance, {0.3, 1} };

