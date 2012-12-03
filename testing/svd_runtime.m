function svd_runtime

fprintf( 'measuring runtime for svd\n');
[p,t,n] = estimate_rate( @svdn, logspace2(200,600,40), 'verbosity', 2, 'doplot', true );
fprintf( 'runtime for svd scales like n ^ %g\n', p);

function A=svdn(n)
A=rand(n);
[u,s,v]=svd(A);

