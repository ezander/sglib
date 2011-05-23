

l=[2,2,2];
p=poly( l )
A=compan(p)
[U,D]=eig(A)
V=U*diag(1./min(U))
W=vander( fliplr(l) )'
%X=W+1e-14*max(abs(W(:)))*repmat(rand(3,1),1,3);
X=W+(V-W)*diag(rand(3,1))*1e3
U\A*U
V\A*V
W\A*W
X\A*X
