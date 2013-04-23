
%% Monte Carlo

N = 100;
state = electrical_network_init();
V = {'p', multiindex(state.num_params, 1)};
u = zeros(state.num_vars, N);
for i = 1:N
    p = gpc_sample(V, 1); % same as rand(2,1)
    u_p = nonlinear_solve_picard(@electrical_network_residual, state, p);
    
    u(:, i) = u_p;
end

mu=mean(u, 2);
sig=std(u, [], 2);
sig2=var(u, [], 2);

underline('Monte-Carlo');
for i = 1:state.num_vars
    fprintf( 'u_%d = %g+-%g\n', i, mu(i), sig(i));
end


%% Quasi Monte Carlo

%% Collocation full grid

state = electrical_network_init();

[x,w] = full_tensor_grid(state.num_params, 5, @gauss_legendre_rule);
w = w / sum(w);
plot(x(1,:),x(2,:),'*k')

N = size(x,2);
u = zeros(state.num_vars, N);
for i = 1:N
    p = x(:, i);
    u_p = nonlinear_solve_picard(@electrical_network_residual, state, p);
    
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
    u_p = nonlinear_solve_picard(@electrical_network_residual, state, p);
    
    u(:, i) = u_p;
end

mu = u * w;
sig2 = (u - repmat(mu, 1, N)).^2 * w;
sig = sqrt(sig2);

underline('Sparse grid integration')
for i = 1:state.num_vars
    fprintf( 'u_%d = %g+-%g\n', i, mu(i), sig(i));
end



%% Projection

%% Interpolation

% show polynomials
state = electrical_network_init();

order = 4;
I = multiindex(state.num_params, order);
% Polynome: 
%  p,P - Legendre
%  l,L - Laguerre
%  h,H - Hermite
%  t,T - Chebyshev 1. kind
%  u,U - Chebyshev 2. kind
V = {'P', I}; 
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


%%

[x,w] = smolyak_grid(state.num_params, 4, @gauss_legendre_rule);
w = w / sum(w);
plot(x(1,:),x(2,:),'*k')

N = size(x,2);
u = zeros(state.num_vars, N);
for i = 1:N
    p = x(:, i);
    u_p = nonlinear_solve_picard(@electrical_network_residual, state, p);
    
    u(:, i) = u_p;
end

mu = u * w;
sig2 = (u - repmat(mu, 1, N)).^2 * w;
sig = sqrt(sig2);

underline('Sparse grid integration')
for i = 1:state.num_vars
    fprintf( 'u_%d = %g+-%g\n', i, mu(i), sig(i));
end


%% Interpolation with radial basis functions

%% Approximation using neural networks

%% Regression

