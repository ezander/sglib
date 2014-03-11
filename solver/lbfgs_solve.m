function r = lbfgs_solve(H0, Y, S, q)

if isempty(H0)
    k0 = length(S);
    %k = k0 - 1;
    k = k0;
else
    k = length(S);
end


alpha = nan(1, k);
beta = nan(1, k);
rho = nan(1, k);
for i=k:-1:1
    rho(i) = 1 / tensor_scalar_product(Y{i}, S{i});
    alpha(i) = rho(i) * tensor_scalar_product(S{i}, q);
    q = tensor_add(q, Y{i}, -alpha(i));
end
if isempty(H0)
    if k0>0
        tau = tensor_scalar_product(Y{k0}, S{k0}) / tensor_scalar_product(Y{k0}, Y{k0});
        r = tensor_scale(q, tau);
    else
        r = q;
    end
else
    r = operator_apply(H0, q);
end
for i=1:k
    beta(i) = rho(i) * tensor_scalar_product(Y{i}, r);
    r = tensor_add(r, S{i}, alpha(i)-beta(i));
end
