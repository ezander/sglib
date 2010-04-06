clf

mh=multiplot_init(3, 1);
%set(h, 'NextPlot', 'add');

x=linspace(0,2*pi);
for d=1:3
    multiplot( mh, 1); 
    plot(sin(x).^d);
    
    multiplot( mh, 2); 
    plot(cos(x).^d); axis equal;
    
    multiplot( mh, 3); 
    plot(tan(x).^d);
end
clc
multiplot( mh, 1); legend( {'$\sin$', '$\sin^2$', '$\sin^3$'}, 'FontSize', 14, 'interpreter', 'none' ); 
multiplot( mh, 2); legend( {'$\cos$', '$\cos^2$', '$\cos^3$'}, 'FontSize', 14, 'interpreter', 'none' );
multiplot( mh, 3); legend( {'$\tan$', '$\tan^2$', '$\tan^3$'}, 'FontSize', 14, 'interpreter', 'none' );


save_thesis_figure( '$mp:11', 'sin', {}, {}, {'view', true} );
%save_thesis_figure( '$mp:21', 'cos' );
%save_thesis_figure( '$mp:31', 'tan' );
