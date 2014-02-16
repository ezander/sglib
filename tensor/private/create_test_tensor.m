function T=create_test_tensor( M, N, R, d )

if nargin<4
    d=1;
end

T={randn(M,R), randn(N,R)};
dc=ctensor_norm(T); 
T{1}=T{1}*d/dc;
