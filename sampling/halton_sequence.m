function q = halton_sequence(n, d, varargin)
% HALTON_SEQUENCE Generate a Halton sequence for QMC integration.
%   Q=HALTON_SEQUENCE(N, D, OPTIONS) generates and N x D array of points
%   for quasi Monte Carlo integration. Each of the D columns contains N
%   points of the van der Corput sequence to base P, where P(J) is the J-th
%   prime number. Additionally to the standard algorithm different start
%   values, scrambling algorithms and column shufflings may be specified.
%
% Options:
%   n0: [1], start value for the van der Corput sequences
%   scramble: [''], specify scrambling algorithm, ''=none, 'bw' or
%   'braaten-weller', 'rev' or 'reverse', 'war' or 'warnock'
%   shuffle: [false], shuffle the ordering in the individual columns
%
% Example (<a href="matlab:run_example halton_sequence">run</a>)
%   halton_sequence(100, 4, 'scramble', 'bw', 'shuffle', true);
%   % Generate the plot from Wikipedia:Halton_sequence
%   clf
%   x = halton_sequence(10, 2, 'n0', 1);
%   plot(x(:,1), x(:,2), 'ro')
%   hold all;
%   x = halton_sequence(90, 2, 'n0', 11);
%   plot(x(:,1), x(:,2), 'bo')
%   hold all;
%   x = halton_sequence(156, 2, 'n0', 101);
%   plot(x(:,1), x(:,2), 'go')
%   axis square
%   hold off;
%
% References:
%   [1] B. Vandewoestyne and R. Cools: Good permutations for scrambled
%       Halton sequences in terms of L2-discrepancy, Report TW 406,
%       September 2004
%
% See also VAN_DER_CORPUT, HAMMERSLEY_SET, GPC_SAMPLE

%   Elmar Zander
%   Copyright 2013, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

options = varargin2options(varargin);
[n0, options] = get_option(options, 'n0', 1);
[scramble, options] = get_option(options, 'scramble', '');
[shuffle, options] = get_option(options, 'shuffle', false);
check_unsupported_options(options, mfilename);

% optional arguments: n0, primes
% scramble, drop_n
% primes need only to be pairwise coprime
p = nprimes(d);
q = zeros(n, d);
for i = 1:d
    switch scramble
        case ''
            scramble_func = [];
        case {'bw', 'braaten-weller'}
            scramble_func = perm_bw(p(i));
        case {'war', 'warnock'}
            scramble_func = @perm_warnock;
        case {'rev', 'reverse'}
            scramble_func = perm_reverse(p(i));
    end
    q(:,i) = van_der_corput(n0:(n+n0-1), p(i), 'scramble_func', scramble_func)';
    if shuffle
        perm = randperm(n);
        q(:,i) = q(perm, i);
    end
end
    


function d = perm_warnock(d, p, j)
% Scrambling according to Warnock (1972)
d = mod((d+j), p);

function scramble_arr = perm_reverse(p)
% Reverse scrambling according to Vandewoestyne and Cools (2004)
scramble_arr = [0, p-1:-1:1];

function scramble_arr = perm_bw(p)
% Scrambling according to Braaten and Weller
perms = bw_permutations();
ind = find([perms{:,1}]==p);
if isempty(ind)
    error('qmc:halton', 'Prime %d not found in list of primes for Braaten-Weller permutations', p);
end
scramble_arr = perms{ind,2};

function perms = bw_permutations
% Permutations for B&W
perms ={2, [0 1];
        3, [0 2 1];
        5, [0 2 4 1 3];
        7, [0 3 5 1 6 2 4];
        11, [0 5 8 2 10 3 6 1 9 4 7];
        13, [0 6 10 2 8 4 12 1 9 5 11 3 7];
        17, [0 8 13 3 11 5 16 1 10 7 14 4 12 2 15 6 9];
        19, [0 9 14 3 17 6 11 1 15 7 12 4 18 8 2 16 10 5 13];
        23, [0 11 17 4 20 7 13 2 22 9 15 5 18 1 14 10 21 6 16 3 19 8 12];
        29, [0 14 22 5 18 9 27 2 20 11 25 7 16 3 24 13 19 6 28 10 1 23 15 12 26 4 17 8 21];
        31, [0 16 8 26 4 22 13 29 2 19 11 24 6 20 14 28 1 17 9 30 10 23 5 21 15 3 27 12 25 7 18];
        37, [0 18 28 6 23 11 34 3 25 14 31 8 20 36 1 16 27 10 22 13 32 4 29 17 7 35 19 2 26 12 30 9 24 15 33 5 21];
        41, [0 20 31 7 26 12 38 3 23 34 14 17 29 5 40 10 24 1 35 18 28 9 33 15 21 4 37 13 30 8 39 19 25 2 32 11 22 36 6 27 16];
        43, [0 21 32 7 38 13 25 3 35 17 28 10 41 5 23 30 15 37 1 19 33 11 26 42 8 18 29 4 39 14 22 34 6 24 12 40 2 31 20 16 36 9 27];
        47, [0 23 35 8 41 14 27 3 44 18 31 11 37 5 25 39 16 21 33 1 46 12 29 19 42 7 28 10 36 22 4 43 17 32 13 38 2 26 45 15 30 6 34 20 40 9 24];
        53, [0 26 40 9 33 16 49 4 36 21 45 12 29 6 51 23 38 14 43 1 30 19 47 10 34 24 42 3 27 52 15 18 39 7 46 22 32 5 48 13 35 25 8 44 31 17 50 2 37 20 28 11 41];
        };

