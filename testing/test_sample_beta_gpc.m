%%
clear
dist_func={@beta_stdnor, {4, 2}, {2, 3}};
[a_i_alpha, I] = pce_expand_1d(dist_func, 4)
V = {'H', I}

N=100000;
xi=gpc_sample(V, N);
y=gpc_evaluate(a_i_alpha, V, xi);
kde(y)


%%
clear

dist = 'beta';
params = {4, 2};
params = {0.5, 0.7};
[shift, scale]=gendist_fix_moments(dist, params, 3.2, 0.24);
x=linspace(-1,5);
plot(x,gendist_pdf(x, dist, params, shift, scale))
hold all
dist_func={@gendist_stdnor, {dist, params, shift, scale}, {2,3,4,5}}

for p=1:6
    [a_i_alpha, I] = pce_expand_1d(dist_func, p)
    V = {'H', I}

    N=100000;
    xi=gpc_sample(V, N);
    y=gpc_evaluate(a_i_alpha, V, xi);
    %kde(y,100)
    empirical_density(y);
    legend('pdf', '1', '2', '3', '4', '5', '6' )
end
