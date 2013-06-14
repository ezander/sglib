function xi = polysys_sample_rv(sys, m, n)
% POLYSYS_SAMPLE_RV Sample from a probability distribution.
%   XI = POLYSYS_SAMPLE_RV(SYS, M, N) samples from the probability
%   distribution corresponding to the system of orthogonal polynomials SYS.
%   An array of size M x N of independently generated samples is returned. 
%
%   Note: Normally you don't want to call this function directly. Rather
%   call GPC_SAMPLE instead.
%
% Example (<a href="matlab:run_example polysys_sample_rv">run</a>)
%    N = 100000; M = 50;
%    subplot(2,3,1)
%    hist(polysys_sample_rv('h', N, 1), M);
%    title('normal')
%    subplot(2,3,2)
%    hist(polysys_sample_rv('p', N, 1), M);
%    title('uniform')
%    subplot(2,3,3)
%    hist(polysys_sample_rv('t', N, 1), M);
%    title('arcsine')
%    subplot(2,3,4)
%    hist(polysys_sample_rv('u', N, 1), M);
%    title('semcircle')
%    subplot(2,3,5)
%    hist(polysys_sample_rv('l', N, 1), M);
%    title('exponential')
%
% See also GPC_SAMPLE, RAND, RANDN

%   Elmar Zander
%   Copyright 2012, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

switch upper(sys)
    case 'H'
        xi = randn(m, n);
    case 'P'
        xi = 2 * rand(m, n) - 1;
    case 'T'
        % Arcsine distribution with support [-1,1] (which is the same as as
        % Beta(1/2,1/2) distribution with shifted support.
        U = rand(m, n);
        xi = 2 * beta_invcdf(U, 1/2, 1/2) - 1;
    case 'U'
        % Wigner semicircle distribution (which is the same as as
        % Beta(3/2,3/2) distribution shift from [0,1] to [-1,1].
        U = rand(m, n);
        xi = 2 * beta_invcdf(U, 3/2, 3/2) - 1;
    case 'L'
        % Exponential distribution
        U = rand(m, n);
        xi = -log(1 - U);
    case 'M'
        error('sglib:gpc:polysys', 'Cannot not sample, since there is no distribution associated with the monomials.');
    otherwise
        error('sglib:gpc:polysys', 'Unknown polynomials system: %s', sys);
end
