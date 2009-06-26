function iteration_plot3( val, tol, t, yl )


clf;
hold on;
h=gca;
cols=get(h,'ColorOrder');
leg={};

for i=1:length(val)
    n=length(val{i});
    plot3( 1:n, logscale(tol{i})*ones(1,n), val{i}, 'x-', 'Color', cols(mod(i,size(cols,1))+1,:) );
    title( t );
    xlabel( 'iter' );
    ylabel( 'log_{10}(\epsilon)' );
    zlabel( yl );
    leg={leg{:}, sprintf('\\epsilon=%g',tol{i} ) };
end
grid on;
view(3)
set(h,'YDir','reverse');
hold off;
