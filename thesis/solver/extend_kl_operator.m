function K=extend_kl_operator( K, I_r )

M_r=size(I_r,1);
G_r=spdiags(multiindex_factorial(I_r),0,M_r,M_r);

for i=1:size(K,1)
    K{i,3}=G_r;
end
