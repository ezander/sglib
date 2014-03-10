function r = lbfgs_solve(H0, Y, S, q)

k = length(S);
alpha = nan(1, k);
beta = nan(1, k);
rho = nan(1, k);
for i=k:-1:1
    rho(i) = 1 / tensor_scalar_product(Y{i}, S{i});
    alpha(i) = rho(i) * tensor_scalar_product(S{i}, q);
    q = tensor_add(q, Y{i}, -alpha(i));
end
r = H0 * q;
for i=1:k
    beta(i) = rho(i) * tensor_scalar_product(Y{i}, r);
    r = tensor_add(r, S{i}, alpha(i)-beta(i));
end
