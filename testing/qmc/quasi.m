function quasi

overview_plot

% function for esimation start-discrepancy
% Halton 1960
% D* = prod_i (3b_i -2)/ln b_i (ln n)^s/N
% Niederreiter 1992
% D* = s/N + 1/N prod_i [ (b_i -1)/(2 ln b_i) ln N + (b_i + 1)/2]
% estimate by MC, generate a_i and compute A(B,P)/N-lambda(B) -> T*


%unittest_quasi
return


function wikipedia_plot
x = halton_sequence(10, 2, 1);
plot(x(:,1), x(:,2), 'ro')
hold all;
x = halton_sequence(90, 2, 11);
plot(x(:,1), x(:,2), 'bo')
hold all;
x = halton_sequence(156, 2, 101);
plot(x(:,1), x(:,2), 'go')
axis equal
hold off;



function overview_plot
n=1000;

subplot(2,2,1)
x = halton_sequence(n, 2);
plot(x(:,1), x(:,2), '.')

subplot(2,2,2)
x = halton_sequence(n, 14);
plot(x(:,11), x(:,13), '.')

subplot(2,2,3)
x = hammersley_set(n, 2);
plot(x(:,1), x(:,2), '.')

subplot(2,2,4)
x = halton_sequence(n, 10);
%plot3(x(:,1), x(:,2), x(:,3), '.')
plot3(x(:,7), x(:,8), x(:,9), '.')


function unittest_quasi
% http://en.wikipedia.org/wiki/Halton_sequence
% http://en.wikipedia.org/wiki/Van_der_Corput_sequence

munit_set_function('van_der_corput');

% test for base 2
assert_equals(van_der_corput(1:9, 2), [1/2, 1/4, 3/4, 1/8, 5/8, 3/8, ...
    7/8, 1/16, 9/16]);
% test for diff start value
assert_equals(van_der_corput(7:9, 2), [7/8, 1/16, 9/16]);
% test for diff shapes (in=out)
assert_equals(van_der_corput(1:9, 2)', [1/2, 1/4, 3/4, 1/8, 5/8, 3/8, ...
    7/8, 1/16, 9/16]');
assert_equals(van_der_corput(ones(3), 2), ones(3)/2);
% test for base 3
assert_equals(van_der_corput(1:9, 3), [1/3, 2/3, 1/9, 4/9, 7/9, 2/9, ...
    5/9, 8/9, 1/27]);
% test for base 10
assert_equals(van_der_corput(1:23, 10), [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, ...
    0.7, 0.8, 0.9, 0.01, 0.11, 0.21, 0.31, 0.41, 0.51, 0.61, 0.71, ...
    0.81, 0.91, 0.02, 0.12, 0.22, 0.32])



munit_set_function('nprimes');

p = nprimes(77);
assert_equals(length(p), 77);
assert_equals(isprime(p), true(1,77));



munit_set_function('halton_sequence');

% test for dim 1
assert_equals(halton_sequence(5, 1), [1/2, 1/4, 3/4, 1/8, 5/8]');
% test for dim 2
assert_equals(halton_sequence(5, 2), [[1/2, 1/4, 3/4, 1/8, 5/8];
    [1/3, 2/3, 1/9, 4/9, 7/9]]');
% test for dim 2, start = 2
assert_equals(halton_sequence(4, 2, 2), [[1/4, 3/4, 1/8, 5/8];
    [2/3, 1/9, 4/9, 7/9]]');


munit_set_function('hammersley_set');

l = (1:5)/5;
% test for dim 1
assert_equals(hammersley_set(5, 1), l');
% test for dim 2
assert_equals(hammersley_set(5, 2), [[1/2, 1/4, 3/4, 1/8, 5/8]; l]');
% test for dim 3
assert_equals(hammersley_set(5, 3), [[1/2, 1/4, 3/4, 1/8, 5/8];
    [1/3, 2/3, 1/9, 4/9, 7/9]; l]');




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

function p=nprimes(m)
if m==0
    p=zeros(1,0);
    return
end
% follows from prime number theorem plus some fitting (i.e. the number of
% of primes smaller than n  is always slightly larger than m)
n = m * log(m) * 1.2 + 3;
p = primes(n);
% the following loop should never execute (its just a precaution, since the
% formula for n above is not guaranteed)
while length(p)<m
    n = n * 2;
    p = primes(n);
end
p = p(1:m);
   

function q = van_der_corput(n, p)
assert(all(n(:)>=0))
assert(all(n(:)==round(n(:) )))

q = zeros(size(n));
f = 1/p;
while true
    r = rem(n, p);
    q = q + f * r;
    n = floor(n/p);
    if all(n(:)==0)
        break;
    end
    f = f/p;
end

