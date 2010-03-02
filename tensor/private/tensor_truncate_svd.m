function [T_k,sigma,k]=tensor_truncate_svd( T, G, eps, k_max, relcutoff, p )
if isempty(G); G={[],[]}; end
[Q1,R1]=qr_internal(T{1},G{1});
[Q2,R2]=qr_internal(T{2},G{2});
[U,S,V]=svd(R1*R2',0);

sigma=diag(S);
k=schattenp_truncate( sigma, eps, relcutoff, p );
k=min(k,k_max);

U_k=U(:,1:k);
S_k=S(1:k,1:k);
V_k=V(:,1:k);

T_k={Q1*U_k*S_k,Q2*V_k};
