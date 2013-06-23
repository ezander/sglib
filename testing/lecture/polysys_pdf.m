function p=polysys_pdf(sys, xi)
% POLYSYS_PDF Short description of polysys_pdf.
%   POLYSYS_PDF Long description of polysys_pdf.
%
% Options
%
% References
%
% Notes
%
% Example (<a href="matlab:run_example polysys_pdf">run</a>)
%
% See also GPC

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

switch upper(sys)
    case 'H'
        p = normal_pdf(xi, 0, 1);
    case 'P'
        p = uniform_pdf(xi, -1, 1);
    case 'T'
        % Arcsine distribution with support [-1,1] (which is the same as as
        % Beta(1/2,1/2) distribution with shifted support.
        p = beta_pdf(0.5*(xi+1), 1/2, 1/2);
    case 'U'
        % Wigner semicircle distribution (which is the same as as
        % Beta(3/2,3/2) distribution shift from [0,1] to [-1,1].
        p = beta_pdf(0.5*(xi+1), 3/2, 3/2);
    case 'L'
        % Exponential distribution
        p = exponential_pdf(xi, 1);
    case 'M'
        error('sglib:gpc:polysys', 'There is no distribution associated with the monomials.');
    otherwise
        error('sglib:gpc:polysys', 'Unknown polynomials system: %s', sys);
end
