%http://ideas.repec.org/p/wiw/wiwrsa/ersa03p406.html
%http://www-sre.wu-wien.ac.at/ersa/ersaconfs/ersa03/cdrom/papers/406.pdf

%% Figure 1
pd = 0.02;
N=100;
x = halton_sequence(100, 15);

subplot(2,2,1);
plot(x(:,1), x(:,2), 'ok');
xlim([-pd, 1+pd]); ylim([-pd, 1+pd]);

subplot(2,2,2);
plot(x(:,10), x(:,11), 'ok');
xlim([-pd, 1+pd]); ylim([-pd, 1+pd]);

subplot(2,2,3);
plot(x(:,14), x(:,15), 'ok');
xlim([-pd, 1+pd]); ylim([-pd, 1+pd]);

subplot(2,2,4);
y = rand(N,2);
plot(y(:,1), y(:,2), 'ok');
xlim([-pd, 1+pd]); ylim([-pd, 1+pd]);

%% Computation of correlation coefficient
N=100;
x = halton_sequence(N, 15);
C = corrcoef(x);
p = nprimes(15);
fprintf('\n\n\n');
fprintf('corrcoeff halton p1=%d, p2=%d: %.3g\n', p(1), p(2), C(1,2))
fprintf('corrcoeff halton p1=%d, p2=%d: %.4g\n', p(10), p(11), C(10,11))
fprintf('corrcoeff halton p1=%d, p2=%d: %.4g\n', p(14), p(15), C(14,15))

M=500;
c = [];
for i=1:M
    y = rand(N,2);
    C = corrcoef(y);
    c(end+1) = abs(C(1,2));
end
fprintf('corrcoeff rand: %.4g+-sqrt(%.4g)\n', mean(c), var(c))


%% Figure 2

N=100;
x = halton_sequence(100, 15, 'scramble', '');

for i = 8:15
    for j = 8:15
        if i==j
            continue
        end
        subplot(8, 8, (j-8)*8 + (i-8) + 1)
        plot(x(:,i), x(:,j), 'ok');
    end
end
%https://lirias.kuleuven.be/bitstream/123456789/131168/1/mcm2005_bartv.pdf
%Bart Vandewoestyne , Ronald Cools
%  Warnock (1972): pi_b,j(d_j) = (d_j+j) mod b
%  Braaten & Weller (1979): pi_b(d) minimise disprepancy of
%  {pi(1),..pi(j)} for each j
%  Mascagni and Chi (2004): pi_n(d) = (w d) mod b
%  reverse {0,b-1,b-2,...,1}, pi_n(d) = (b-1)d mod b (supposed to be good
%  according to the slides)
% Randomised:
%   Cranley-Patterson: add rand() mod 1
%   Random start: set n0 dependent on j, randomly and not 1
%   Random shuffle: shuffle along each dimension