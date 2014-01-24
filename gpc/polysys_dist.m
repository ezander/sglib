function dist=polysys_dist(sys)
% POLYSYS_DIST Get the associated distribution for a polynomial system.
%   DIST=POLYSYS_DIST(SYS) returns the probability distribution associated
%   with the orthogonal system of polynomials SYS.
%
% Example (<a href="matlab:run_example polysys_dist">run</a>)
%
% See also

%   Elmar Zander
%   Copyright 2014, Inst. of Scientific Computing, TU Braunschweig
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
        % Hermite/Gauss
        dist = gendist_create('normal', {0, 1});
    case 'P'
        % Legendre/Uniform
        dist = gendist_create('uniform', {-1, 1});
    case 'T'
        % ChebyshevT/Shifted Arcsine
        % Arcsine distribution with support [-1,1] (which is the same as as
        % Beta(1/2,1/2) distribution with shifted support.
        dist = gendist_create('beta', {1/2, 1/2}, 'shift', -1/2, 'scale', 2);
    case 'U'
        % ChebyshevU/Semicircle
        % Wigner semicircle distribution (which is the same as as
        % Beta(3/2,3/2) distribution shift from [0,1] to [-1,1].
        dist = gendist_create('beta', {3/2, 3/2}, 'shift', -1/2, 'scale', 2);
    case 'L'
        % Laguerre/Exponential
        dist = gendist_create('exponential', {1});
    case 'M'
        % Monomials/(no distribution)
        error('sglib:gpc:polysys', 'Cannot not sample, since there is no distribution associated with the monomials.');
    otherwise
        error('sglib:gpc:polysys', 'Unknown polynomials system: %s', sys);
end
