%% Monte Carlo

N = 100;
[u_mean, u_var] = compute_moments_mc(@electrical_network_init, @electrical_network_solve, 'p', N);
show_mean_var('Monte-Carlo', u_mean, u_var)


%% Quasi Monte Carlo

%% Collocation full grid

%[u_mean, u_var] = compute_moments_quad(@electrical_network_init, @electrical_network_solve, 'p', 5, 'smolyak');
show_mean_var('Monte-Carlo', u_mean, u_var)

state = electrical_network_init();

xw = gpc_integrate([], {'p', [0, 0]}, 5, 'grid', 'full_tensor')
[x,w]=deal(xw{:});

N = size(x,2);
u = zeros(state.num_vars, N);
for i = 1:N
    p = x(:, i);
    u_p = electrical_network_solve(state, p);
    
    u(:, i) = u_p;
end

mu = u * w;
sig2 = (u - repmat(mu, 1, N)).^2 * w;
sig = sqrt(sig2);

underline('Full tensor grid integration')
for i = 1:state.num_vars
    fprintf( 'u_%d = %g+-%g\n', i, mu(i), sig(i));
end


%% Collocation sparse grid

state = electrical_network_init();

[x,w] = smolyak_grid(state.num_params, 4, @gauss_legendre_rule);
w = w / sum(w);
plot(x(1,:),x(2,:),'*k')

N = size(x,2);
u = zeros(state.num_vars, N);
for i = 1:N
    p = x(:, i);
    u_p = electrical_network_solve(state, p);
    
    u(:, i) = u_p;
end

mu = u * w;
sig2 = (u - repmat(mu, 1, N)).^2 * w;
sig = sqrt(sig2);

underline('Sparse grid integration')
for i = 1:state.num_vars
    fprintf( 'u_%d = %g+-%g\n', i, mu(i), sig(i));
end



%% Show polynomials
order = 3;
I = multiindex(2, order);
% Polynome: 
%  p,P - Legendre
%  l,L - Laguerre
%  h,H - Hermite
%  t,T - Chebyshev 1. kind
%  u,U - Chebyshev 2. kind
V = {'p', I}; 
for ind = 1:size(I,1)
    %xi = gpc_sample(V, 10000);
    [X,Y]=meshgrid(linspace(-1,1,40));
    e = zeros(1,size(I,1));
    e(ind)=1;
    xi = [X(:), Y(:)]';
    Z = gpc_evaluate( e, V, xi);
    surf(X, Y, reshape(Z,size(X)));
    title(sprintf('P_{(%d,%d)}', I(ind,1), I(ind,2)))
    pause(1)
end


%% Projection

state = electrical_network_init();

order = 3;
I = multiindex(state.num_params, order);
V = {'P', I}; 

[x,w] = smolyak_grid(state.num_params, 4, @gauss_legendre_rule);
w = w / sum(w);

M = size(I,1);
N = size(x,2);
u = zeros(state.num_vars, M);
for k = 1:N
    p = x(:, k);
    u_k = electrical_network_solve(state, p);
    P_jk = gpc_evaluate(eye(M), V, p);
    u = u + w(k) * u_k * P_jk';
end

u_normed = u * diag(1./gpc_norm(V));
mu = u_normed(:,1);
sig2 = sum(u_normed(:,2:end).^2, 2);
sig = sqrt(sig2);

%[u_mean, u_var] = gpc_moments(u, V);



underline('Projection (L_2, response surface)')
for i = 1:state.num_vars
    fprintf( 'u_%d = %g+-%g\n', i, mu(i), sig(i));
end


%% Interpolation

%% Interpolation with radial basis functions

%% Approximation using neural networks

%% Regression

