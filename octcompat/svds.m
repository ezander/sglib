function [U,S,V]=svds( A, k )

[U,S,V]=svd( A );
U=U(:,1:k);
S=S(1:k,1:k);
V=V(:,1:k);
