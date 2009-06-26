function iteration_plot( val, tol, t, yl, di, dy )

if ~exist('di','var') || isempty(di)
    di=0;
end
if ~exist('dy','var') || isempty(dy)
    dy=0;
end

clf
hold on;
cols=get(gca,'ColorOrder');
leg={};
for i=1:length(val)
    plot( di*(i-1)+(1:length(val{i})), dy*(i-1)+val{i}, 'x-', 'Color', cols(mod(i,size(cols,1))+1,:) );
    title( t );
    xlabel( 'iter' );
    ylabel( yl );
    leg={leg{:}, sprintf('\\epsilon=%g',tol{i} ) };
end
legend(leg);

hold off;
