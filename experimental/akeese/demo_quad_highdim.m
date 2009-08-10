n=3; s=7;
subplot(2,3,1);
tic; [x,w]=smolyak_rule( n, s, @gauss_legendre_rule); toc;
sum(size(x')-size(unique(x','rows')))
plot( x(1,:), x(2,:), 'x' );

subplot(2,3,2);
tic; [x,w]=smolyak_rule( n, s, @gauss_hermite_rule); toc;
sum(size(x')-size(unique(x','rows')))
plot( x(1,:), x(2,:), 'x' );

subplot(2,3,3);
tic; [x,w]=smolyak_rule( n, (s+1)/2, @clenshaw_curtis_legendre_rule); toc; 
sum(size(x')-size(unique(x','rows')))
plot( x(1,:), x(2,:), 'x' );


subplot(2,3,4);
tic; [x,w]=full_tensor_rule( n, s, @gauss_legendre_rule);  toc;
sum(size(x')-size(unique(x','rows')))
plot( x(1,:), x(2,:), 'x' );

subplot(2,3,5);
tic; [x,w]=full_tensor_rule( n, s, @gauss_hermite_rule);  toc;
sum(size(x')-size(unique(x','rows')))
plot( x(1,:), x(2,:), 'x' );

subplot(2,3,6);
tic; [x,w]=full_tensor_rule( n, (s+1)/2, @clenshaw_curtis_legendre_rule); toc;
sum(size(x')-size(unique(x','rows')))
plot( x(1,:), x(2,:), 'x' );
