function K=extend_kl_operator( K, I_r )

M_r=size(I_r,1);
G_r=spdiags(multiindex_factorial(I_r),0,M_r,M_r);
K=tensor_operator_extend( K, G_r, 3 );
