function q = halton_sequence(n, d, n0)
if nargin<3
    n0=1;
end

% optional arguments: n0, primes
% scramble, drop_n
% primes need only to be pairwise coprime
p = nprimes(d);
q = zeros(n, d);
for i = 1:d
    q(:,i) = van_der_corput(n0:(n+n0-1), p(i));
end

