function [mean,var,skew,kurt]=pce_moments( pcc, pci ) %#ok: kurt never assigned
% PCE_MOMENTS Calculate the statistical moments of a distribution given as PCE.
%   [MEAN,VAR,SKEW,KURT]=PCE_MOMENTS( PCC, PCI ) calculate mean, variance,
%   skewness and kurtosis for a distribution given by the coefficients in
%   PCC. PCC can also be a field of PC expansions where PCC(i,:) is the
%   expansion at point x_i. The output arguments VAR, SKEW and KURT are
%   optional and only calculated if required. PCI is optional and contains
%   the indices of the Hermite polynomials.
%
%   Caveat: currently only MEAN, VAR and SKEW are calculated. KURT has
%   to be implemented yet.
%
% Example (<a href="matlab:run_example pce_moments">run</a>)
%   [pcc,pci]=pce_expand_1d( @exp, 12 );
%   [mean,var,skew]=pce_moments( pcc );
%   [mean,var,skew]=pce_moments( pcc, pci );
%   [mean,var,skew]=lognormal_moments( 0, 1);
%
% See also PCE_EXPAND_1D, DATA_MOMENTS

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
    p=size(pcc,2)-1;
    n=size(pcc,1);

    % Coefficient a_0 (=pcc(1)) of H_0 is the mean of the PCE
    mean = pcc(:,1);

    % Variance is equal to \sum_{i=1}^\infty i\! a_i^2
    % (Important: start with 1(2) to exclude mean).
    % The first part of the expression calculated the squares of the
    % coefficients, while the seconds part calculates the factorials and
    % repeats them for all entries.)
    if nargout>=2
        var = sum(pcc(:,2:end).^2.*repmat(factorial(1:p),n,1),2);
    end
    if nargout>=3
        skew=zeros(n,1);
        for i=1:p
            for j=1:i
                for k=1:j
                    h_ijk=hermite_triple_product(i,j,k);
                    if h_ijk~=0
                        % correct for possible permutations (because j and
                        % k don't run over the full range but only up to
                        % the enclosing index)
                        if i>j && j>k
                            n_perm=6;
                        elseif i==j && j>k
                            n_perm=3;
                        elseif i>j && j==k
                            n_perm=3;
                        else % i==j && j==k
                            n_perm=1;
                        end
                        skew=skew+pcc(:,i+1).*pcc(:,j+1).*pcc(:,k+1)*h_ijk*n_perm;
                    end
                end
            end
        end
        skew=skew/(var^1.5);
    end
else
    % get the max. order of the pce
    p=size(pcc,2)-1;
    % get the number of coefficient sets (i.e. the number of multivariate
    % Hermite polynomials)
    n=size(pcc,1);

    % the first row in PCI should contain the mean (i.e. all indices have
    % to be zero)
    if any(full(pci(1,:))~=0)
        error('pce_moments: the first row in argument pci has to be identical zero!' );
    end

    mean = pcc(:,1);
    if nargout>=2
        %         var=zeros(1,n);
        %         for i=1:n
        %             var(i)=pcc(i,2:end).^2*multiindex_factorial(pci(2:end,:));
        %         end
        var=pcc(:,2:end).^2*multiindex_factorial(pci(2:end,:));
    end
    if nargout>=3
        %TODO: maybe for large multiindex sets the skewness should be
        % calculated by monte-carlo simulation (or is there another way to
        % speed things up?)

        skew=zeros(n,1);
        hermite_triple_fast(max(pci(:))); % initialize
        for i=2:p+1
            for j=2:i
                for k=2:j
                    h_abc=hermite_triple_fast(pci(i,:),pci(j,:),pci(k,:));
                    if h_abc~=0
                        % correct for possible permutations (because j and
                        % k don't run over the full range but only up to
                        % the enclosing index)
                        if i>j && j>k
                            n_perm=6;
                        elseif i==j && j>k
                            n_perm=3;
                        elseif i>j && j==k
                            n_perm=3;
                        else % i==j && j==k
                            n_perm=1;
                        end

                        skew=skew+pcc(:,i).*pcc(:,j).*pcc(:,k)*h_abc*n_perm;
                    end
                end
            end
        end
        skew=skew./(var.^1.5);
    end
end

if nargout>=4
    %TODO: implement computation of kurtosis, will probably be very slow, MC or smolyak?
    error('Calculation of KURT not yet implemented!');
end

