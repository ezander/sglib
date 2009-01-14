function plot_field( els, pos, u )

if ismatlab()
    trimesh( els, pos(:,1), pos(:,2), u );
    hold on
    trisurf( els, pos(:,1), pos(:,2), u );
    hold off
    view(2);
    axis( 'equal' );
    xlim([min(pos(:,1)) max(pos(:,1))]);
    ylim([min(pos(:,2)) max(pos(:,2))]);
    shading( 'interp' );
    %lighting flat;
    drawnow;
else
    fprintf('plot_field not yet implemented for octave\n');
end
