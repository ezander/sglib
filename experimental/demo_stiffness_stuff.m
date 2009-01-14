function demo_stiffness_stuff

addpath ../
addpath ../munit
addpath ../util
addpath ../experimental
addpath ../simplefem




k=1+(x-.5).^2;
k=1*ones(size(x));


stiffness_multiply_func=mk_matrix_multiply_func( stiffness_matrix_func, k );


K=funcall( stiffness_func, k );

B_ind=[1,21];
f=-8/(n-1)*sin((x-0.5)*2*pi).*ones(size(x));
g=0.5*x+2;
%g=zeros(size(x));

I_ind=setdiff(1:21, B_ind);

u=zeros(size(x));
u(B_ind)=g(B_ind);
u(I_ind)=K(I_ind,I_ind)\( f(I_ind) - K(I_ind,B_ind)*g(B_ind) );
%u(I_ind)=K(I_ind,I_ind)\( f(I_ind) - K(I_ind,B_ind)*g(B_ind) );
%pcg( @(x)(K*x), 
u(I_ind)=pcg( @(x)(K(I_ind,I_ind)*x), f(I_ind) - K(I_ind,B_ind)*g(B_ind) );

subplot(2,2,1)
plot(x,k)
subplot(2,2,2)
plot(x,f)
subplot(2,2,3)
plot(x,u)

return





% definition of the grid
function [K,I_ind]=stiffness_func(k)
n=21;
x=linspace(0,1,n)';
els=[1:n-1; 2:n]';
M=mass_matrix( els, x );
K=stiffness_matrix( els, x, k );
I_ind=[1,21];

% stiffness_matrix_func: kappa->K






% we need probably a two level indirection here
%  the stochastic galerkin code needs to call a function that computes the
%  product of a vector with the stiffness matrix given a certain other
%  matrix, say:
%      Ku=stiffness_multiply( kappa_i, i, u )
%  The function stiffness_multiply



function multiply_func=mk_matrix_multiply_func( matrix_func, kappa )
[K, I_ind]=funcall( matrix_func, kappa );
multiply_func={ @matrix_multiply, {K, I_ind}, {1, 3} };

function y=indexed_multiply( multiply_func, Y_ind, X_ind, x )
xf=zeros(size(x));
xf(X_ind)=x(X-ind);
yf=funcall( multiply_func, x2 );
y=yf(Y_ind);


function [y, varargout]=matrix_multiply( M, x, varargin )
y=M*x;
varargout=varargin;
