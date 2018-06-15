function y_j_k = compute_measurement(xi_i_k, g_func, Q, varargin)
options=varargin2options(varargin);
[is_xi_stdnor,options]=get_option(options, 'is_xi_stdnor', false);
check_unsupported_options(options,mfilename);

if is_xi_stdnor
    q_i_k=Q.stdnor2params(xi_i_k);
else
    q_i_k=Q.germ2params(xi_i_k);
end
L = size(xi_i_k, 2);


q_1 = q_i_k(:,1);
y_1 = funcall(g_func, q_1);
y_j_k = zeros(size(y_1, 1), L);
y_j_k(:,1) = y_1;

for k=2:L
    q_i = q_i_k(:,k);
    y_j = funcall(g_func, q_i);
    y_j_k(:,k) = y_j;
end
