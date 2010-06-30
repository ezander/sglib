clc
clf
K_pool=[10  20   30  40  50  100  200 300 400 500  1000  2000  3000  4000  5000 10000  20000  30000  40000  50000];
for k=K_pool
    p= UD_points(2,  k );
    disp(k);
    plot( p(1,:), p(2,:), '.' );
    axis equal;
    xlim([0,1]);
    ylim([0,1]);
    title( sprintf( 'k=%d', k ) );
    waitforbuttonpress;
end
