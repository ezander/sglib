function y=apply_flat_truncate(A,x,shape,m)
xs=reshape(x,shape);
ys=apply_stochastic_operator(A,xs);
ys=truncated_svd(x,m);
y=reshape(ys,size(x));

%%
