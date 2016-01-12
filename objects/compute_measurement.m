function y_j_k = compute_measurement(xi_i_k, g_func, Q)
q_i_k=Q.germ2params(xi_i_k);
L = size(xi_i_k, 2);

for k=1:L
    q_i = q_i_k(:,k);
    y_j = funcall(g_func, q_i);
    if k==1
        y_j_k = zeros(size(y_j, 1), L);
    end
    y_j_k(:,k) = y_j;
end
