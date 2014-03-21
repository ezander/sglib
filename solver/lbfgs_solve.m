function q = lbfgs_solve(H0, Y, S, q)

q = lbfgs_solve_iterative(H0, Y, S, q);
%r = lbfgs_solve_recursive(H0, Y, S, q, length(S));

function q = lbfgs_solve_recursive(H0, Y, S, q, k)

if k==0
    q = operator_apply(H0, q);
    return;
end

inner_ys = tensor_scalar_product(Y{k}, S{k});

inner_sq = tensor_scalar_product(S{k}, q);
q = tensor_add(q, Y{k}, -inner_sq/inner_ys);

q = lbfgs_solve_recursive(H0, Y, S, q, k-1);

inner_yr = tensor_scalar_product(Y{k}, q);
q = tensor_add(q, S{k}, (inner_sq-inner_yr)/inner_ys);



function q = lbfgs_solve_iterative(H0, Y, S, q)
k = length(S);
inner_sq = nan(1, k);
inner_yr = nan(1, k);
inner_ys = nan(1, k);
for i=k:-1:1
    inner_ys(i) = tensor_scalar_product(Y{i}, S{i});
    inner_sq(i) = tensor_scalar_product(S{i}, q);
    q = tensor_add(q, Y{i}, -inner_sq(i)/inner_ys(i));
end
q = operator_apply(H0, q);
for i=1:k
    inner_yr(i) = tensor_scalar_product(Y{i}, q);
    q = tensor_add(q, S{i}, (inner_sq(i)-inner_yr(i))/inner_ys(i));
end
