%T=ktensor( {rand(70,5), rand(30,5), [ones(1,5); zeros(19,5)] } );

clear
load T.mat
rand('seed',  109845 );
OPTS.tol=1e-5;
OPTS.maxiters=50;
OPTS.init='random';
OPTS.printitn=5;
U=cp_als( T, 30, OPTS );

