function C=pce_covariance( pcc, pci )
% PCE_COVARIANCE Computes the covariance between variables in a PC
% expansion.
%   C=PCE_COVARIANCE( PCC, PCI ) computes the covariances between each pair
%   of sets of coefficients fiven in PCC (i.e. PCC(:,i)). PCI (optional)
%   contains the multiindices of the multivariate Hermite polynomials.
%
% See also PCE_MOMENTS

%   Elmar Zander
%   Copyright 2006, Institute of Scientific Computing, TU Braunschweig.
%   $Id$
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


if nargin==1
    % get the max. order of the pce
    p=size(pcc,1)-1;
    n=size(pcc,2);

    % Variance is equal to \sum_{i=1}^\infty i\! a_i^2
    % (Important: start with 1(2) to exclude mean).
    % The first part of the expression calculated the squares of the
    % coefficients, while the seconds part calculates the factorials and
    % repeats them for all entries.)
    C=zeros(n,n);
    for i=1:n
        for j=1:i
            C(i,j) = sum(pcc(2:end,i).*pcc(2:end,j).*factorial(1:p)',1);
            C(j,i) = C(i,j);
        end
    end
else
    % get the number of coefficient sets (i.e. the number of multivariate
    % Hermite polynomials)
    if 0
        % This here is the old unvectorized (slow) version
        n=size(pcc,2);

        C=zeros(n,n);
        for i=1:n
            for j=1:i
                C(i,j) = sum(pcc(2:end,i).*pcc(2:end,j).*multiindex_factorial(pci(2:end,:)),1);
                C(j,i) = C(i,j);
            end
        end
    end

    f=multiindex_factorial(pci(2:end,:));
    C=pcc(:,2:end,:)*row_col_mult( pcc(:,2:end)', f );
end


