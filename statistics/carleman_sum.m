function S=carleman_sum(dist_or_moments, N, varargin)
% CARLEMAN_SUM Computes the sum appearing in Carleman's condition.
%   S=CARLEMAN_SUM(DIST, N, OPTIONS) computes the partial sums appearing in
%   the Carleman's condition for the distribution DIST for moments up to N.
%   The behaviour of S for large N gives an indication of whether the sum
%   diverges and the moment problem is uniquely solvable [1]. This in turn
%   determines whether the orthogonal polynomials of the distribution are
%   dense [2] on the real line with the measure induced (note that this is
%   a sufficient condition for the uniqueness of the moment problem).
%
% Options:
%   'hamburger': {true}, false
%     Compute the sum for the Hamburger moment problem (on the whole real
%     line). If set to false the formula for the Stieltjes moment problem
%     is used (moment problem on the positive half-line). For GPC expansion
%     only the Hamburger moment problem is of interest.
%
% Note:
%   Carleman's condition determines whether the Hamburger or (the
%   Stieltjes) moment problem is uniquely solvable, which it is, if the sum
%   appearing in the condition is diverging to positive infinity. If the
%   condition for the Hamburger moment problem is fulfilled, then the
%   orthogonal polynomials for the distribution are dense on the real line.
%
% References:
%   [1] Wikipedia: http://en.wikipedia.org/wiki/Carleman%27s_condition
%   [2] Oliver G. Ernst1, Antje Mugler, Hans-Jörg Starkloff, and Elisabeth
%       Ullmann: On the Convergence of Generalized Polynomial Chaos
%       Expansions, M2AN 46 (2012) 317–339, DOI: 10.1051/m2an/2011045
%
% Example (<a href="matlab:run_example carleman_sum">run</a>)
%   multiplot_init(2,2)
%   dist=gendist_create('beta', {2, 3}); name='Beta(2,3)';
%   multiplot; plot(carleman_sum(dist, 40)); title(name);
%   dist=gendist_create('normal', {1, 2}); name='Normal(1,2)';
%   multiplot; plot(carleman_sum(dist, 40)); title(name);
%   dist=gendist_create('exponential', {1.6}); name='Exp(1.6)';
%   multiplot; plot(carleman_sum(dist, 40)); title(name);
%   dist=gendist_create('lognormal', {0, 1}); name='LogNormal(0,1)';
%   multiplot; plot(carleman_sum(dist, 40)); title(name);
%
% See also GPC

%   Elmar Zander
%   Copyright 2015, Inst. of Scientific Computing
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

options=varargin2options(varargin, mfilename);
[hamburger,options]=get_option(options, 'hamburger', true);
check_unsupported_options(options);

if isnumeric(dist_or_moments)
    S = carleman_sum_int(dist_or_moments, hamburger);
else
    m = gendist_raw_moments(1:N, dist_or_moments);
    S = carleman_sum_int(m, hamburger);
end

function S=carleman_sum_int(m, hamburger)
N = length(m);
if hamburger
    n = 2:2:N;
    s = m(n).^(-1./n);
else % stieltjes
    n = 1:N;
    s = m(n).^(-1./(2*n));
end
S = cumsum(s);
