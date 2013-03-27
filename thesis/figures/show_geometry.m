function show_geometry

multiplot_init(2,2)

models={'small', 'medium', 'large', 'huge' };
for i=1:3
    plot_geom( models{i} );
end



function plot_geom( basemodel_ )

eval( ['model_', basemodel_, '_easy']) 
define_geometry

multiplot;
plot_mesh( pos, els, 'bndcolor', 'k', 'bndwidth', 1 )
axis equal; axis square;
save_figure( gca, {'geometry-model_%s', basemodel_}, 'afterreparent', @axis_style );

function axis_style( handle, fighandle )
axis( handle, 'equal' );
axis( handle, 'square' );
