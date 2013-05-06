function q = hammersley_set(n, d)
% optional arguments: primes
% scramble, drop_n (on halton part)
% primes need only to be pairwise coprime
p = nprimes(d-1);
q = zeros(n, d);
for i = 1:(d-1)
    q(:,i) = van_der_corput(1:n, p(i));
end
q(:,d) = (1:n)/n;

