%http://dlmf.nist.gov/18.7#E4

x=linspace(-1,1,100);
p=5;
n=0:p;
%% check connection between Jacobi and Chebyshev (U) polynomials
% U_n=(n+1)J_n(1/2,1/2)(x)/J_n(1/2,1/2)(1)

a=1.5;
b=1.5;
dist=BetaDistribution(a,b);
dist=dist.fix_bounds(-1,1);
gpc_register_polysys('j', dist, JacobiPolynomials(a-1, b-1,0));
V_ju=gpcbasis_create('j', 'p', p);
y_ju=binfun(@times, gpcbasis_evaluate(V_ju,x), (n+1)'); 
y_ju=binfun(@times, y_ju, 1./gpcbasis_evaluate(V_ju,1) );
%evaluate Chebyshev polynomials
V_u=gpcbasis_create('u', 'p', 5);
y_u=gpcbasis_evaluate(V_u,x);

subplot(3,1,1)
plot(x,y_ju(1:4, :), 'linewidth', 2)
hold on
plot(x,y_u(1:4, :), 'x')
plot([-1,1], [0,0])
title('Chek equality between Jacobi and Chebyshev (U)')

%% check connection between Jacobi and Chebyshev (T) polynomials
% T_n=n(alpha=-1/2,beta=-1/2)(x)/Jn(alpha=-1/2,beta=-1/2)(1)
% with the notation of SGLIB:
% T_n=n(a=1/2,b=1/2)(2x-1)/Jn(a=1/2,b=1/2)(1)
a=0.5;
b=0.5;
dist=BetaDistribution(a,b);
dist=dist.fix_bounds(-1,1);
gpc_register_polysys('k', dist, JacobiPolynomials(a-1, b-1,0));

V_jt=gpcbasis_create('k', 'p', 5);
y_jt=gpcbasis_evaluate(V_jt,x);
y_jt=binfun(@times, y_jt, 1./gpcbasis_evaluate(V_jt,1) );
V_t=gpcbasis_create('t', 'p', 5);
y_t=gpcbasis_evaluate(V_t,x);
subplot(3,1,2)
plot(x,y_jt(1:4, :), 'linewidth', 2)
hold on
plot(x,y_t(1:4, :), 'x')
plot([-1,1], [0,0])
title('Chek equality between Jacobi and Chebyshev (T)')
%% check connection between Jacobi and Legendre (P) polynomials
a=1;
b=1;
dist=BetaDistribution(a,b);
dist=dist.fix_bounds(-1,1);
gpc_register_polysys('F', dist,  JacobiPolynomials(a-1, b-1,0));


V_jp=gpcbasis_create('f', 'p', 5);
y_jp=gpcbasis_evaluate(V_jp,x);
V_p=gpcbasis_create('p', 'p', 5);
y_p=gpcbasis_evaluate(V_p,x);
subplot(3,1,3)
plot(x,y_jp(1:4, :), 'Linewidth', 2)
hold on
plot(x,y_p(1:4, :), 'x')
plot([-1,1], [0,0])
title('Chek equality between Jacobi and Legendre (P)')