function altest


d = 3;
I_z = multiindex(4, 3);
V_z = {'H', I_z};
z_i_alpha = randn(d, size(I_z, 1));
z_i_alpha(:,3:6) = 0;
z_i_alpha(:,15:26) = 0;

xi = gpc_sample(V_z, 10);
z1 = gpc_evaluate(z_i_alpha, V_z, xi);

find(gpc_get_support(z_i_alpha))

[z_i_alpha, V_z] = gpc_reduce_basis(z_i_alpha, V_z);
z2 = gpc_evaluate(z_i_alpha, V_z, xi);

find(gpc_get_support(z_i_alpha))
norm(z1-z2)


function non_zero_indices = gpc_get_support(x_i_alpha, varargin)

options = varargin2options(varargin);
[delta, options]= get_option(options, 'delta', 1e-10);
[include_mean, options] = get_option(options, 'include_mean', true);
check_unsupported_options(options, mfilename);

non_zero_indices = sum(abs(x_i_alpha), 1)>delta;
if include_mean
    non_zero_indices(1) = true;
end



function [x_i_alpha, V_x] = gpc_reduce_basis(x_i_alpha, V_x, varargin)

options = varargin2options(varargin);
[delta, options]= get_option(options, 'delta', 1e-10);
[include_mean, options] = get_option(options, 'include_mean', true);
check_unsupported_options(options, mfilename);

non_zero_indices = gpc_get_support(x_i_alpha, {'delta', delta, 'include_mean', include_mean});
x_i_alpha = x_i_alpha(:, non_zero_indices);
V_x{2} = V_x{2}(non_zero_indices, :);
