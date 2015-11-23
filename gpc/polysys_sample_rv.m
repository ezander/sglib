function xi = polysys_sample_rv(syschar, m, n)
% POLYSYS_SAMPLE_RV Sample from a probability distribution.
%   XI = POLYSYS_SAMPLE_RV(SYSCHAR, M, N, DIST_PARAMS) samples from the
%   probability distribution corresponding to the system of orthogonal
%   polynomials SYSCHAR. An array of size M x N of independently generated
%   samples is returned.
%
%   Note: Normally you don't want to call this function directly. Rather
%   call GPCGERM_SAMPLE instead.
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
% See also GPCGERM_SAMPLE, RAND, RANDN

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

dist = polysys_dist(syschar);
if iscell(dist)&&strcmpi(dist{1},'none')
    error('sglib:gpc', 'err_monomials, there is no distribution associated with Monomials')
end
if nargin<3 || isempty(n)
    U = m;
    xi = gendist_invcdf(U, dist);
else
    xi = gendist_sample([m, n], dist);
end
