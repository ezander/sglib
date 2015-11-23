function dist=polysys_dist(syschar, varargin)
% POLYSYS_DIST Get the associated distribution for a polynomial system.
%   DIST=POLYSYS_DIST(SYSCHAR) returns the probability distribution associated
%   with the orthogonal system of polynomials SYSCHAR.
%
% Example (<a href="matlab:run_example polysys_dist">run</a>)
%
% See also POLYSYS_SAMPLE_RV, GPCGERM_PDF, GPCGERM_CDF, GPCGERM_SAMPLE

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

switch upper(syschar)
    case 'H'
        % Hermite/Gauss
        dist = gendist_create('normal', {0, 1});
    case 'P'
        % Legendre/Uniform
        dist = gendist_create('uniform', {-1, 1});
    case 'T'
        % ChebyshevT/Shifted Arcsine
        dist = gendist_create('arcsine', {}, 'shift', -0.5, 'scale', 2);
    case 'U'
        % ChebyshevU/Semicircle
        dist = gendist_create('semicircle');
    case 'L'
        % Laguerre/Exponential
        dist = gendist_create('exponential', {1});
    case 'M'
        % Monomials/(no distribution)
        error('sglib:gpc:polysys', 'Cannot not sample, since there is no distribution associated with the monomials.');
    otherwise
        [~, dist]=gpc_registry('get', syschar);
        if isempty(dist)
            error('sglib:gpc:polysys', 'Unknown polynomial system char: %s', syschar);
        end
end
