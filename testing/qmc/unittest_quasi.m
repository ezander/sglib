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




