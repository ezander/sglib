I=multiindex(m,p,[],'use_sparse', true);
M=size(I,1);
numel=numel(I);
nnz=nnz(I);
clear I
