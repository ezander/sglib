function y=apply_flat(A,x,shape)
xs=reshape(x,shape);
ys=apply_stochastic_operator(A,xs);
y=reshape(ys,size(x));

%%
