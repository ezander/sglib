classdef Monomials < PolynomialSystem
    % MONOMIALS Construct the Monoials.
    %
    % Example (<a href="matlab:run_example Monomials">run</a>)
    %   polysys=Monomials();
    %   x=linspace(-1,1);
    %   y=polysys.evaluate(4, x);
    %   plot(x,y);
    %
    % See also POLYNOMIALSYSTEM LEGENDREPOLYNOMIALS
    
    %   Noemi Friedman, Elmar Zander
    %   Copyright 2014, Inst. of Scientific Computing, TU Braunschweig
    %
    %   This program is free software: you can redistribute it and/or modify it
    %   under the terms of the GNU General Public License as published by the
    %   Free Software Foundation, either version 3 of the License, or (at your
    %   option) any later version.
    %   See the GNU General Public License for more details. You should have
    %   received a copy of the GNU General Public License along with this
    %   program.  If not, see <http://www.gnu.org/licenses/>.
    
    properties (SetAccess=protected)
    end
    
    methods
        function polysys=Monomials()
            % MONOMIALS Construct the Monomials.
            %   POLYSYS=MONOMIALS() constructs a polynomial system
            %   representing the monomials.
            %   Note: that there is no weight function that would make the
            %   monomials orthogonal, so it is not really used in any form
            %   of GPC expansion. However, it is sometimes handy to have
            %   also multivariate representations in monomial form, for
            %   which this polynomials system can then be used.
        end
        
        function r=recur_coeff(~, deg)
            % RECUR_COEFF Compute recurrence coefficient of the monomials.
            n = (0:deg-1)';
            one = ones(size(n));
            zero = zeros(size(n));
            r = [zero, one, zero];
        end
        
        function nrm2=sqnorm(~, ~) %#ok<STOUT>
            % SQNORM Computing the square norm of the monomials raises an error.
            %
            % See also POLYNOMIALSYSTEM.SQNORM
            error('sglib:monomials:sqnorm', 'There is no weighting function for the monomials, thus also no norm!');
        end
    end
end
