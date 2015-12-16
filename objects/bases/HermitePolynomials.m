classdef HermitePolynomials < PolynomialSystem
    % HERMITEPOLYNOMIALS Class representing the probabilists Hermite polynomials.
    %
    % Example (<a href="matlab:run_example HermitePolynomials">run</a>)
    %   polysys=HermitePolynomials();
    %   x=linspace(-3,3);
    %   y=polysys.evaluate(4, x);
    %   plot(x,y);
    %
    % See also LEGENDREPOLYNOMIALS POLYNOMIALSYSTEM
    
    %   Elmar Zander, Aidin Nojavan, Noemi Friedman
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
        function polysys=HermitePolynomials()
            % HERMITEPOLYNOMIALS Construct the HermitePolynomials.
            %   POLYSYS=HERMITEPOLYNOMIALS() constructs polynomial system
            %   representing the probabilist's Hermite polynomials.
        end
        
        function r=recur_coeff(~, deg)
            % RECUR_COEFF Compute recurrence coefficient of Hermite polynomials.
            %
            % See also POLYNOMIALSYSTEM.RECUR_COEFF
            %
            % References:
            %   [1] http://dlmf.nist.gov/18.9.i
            n = (0:deg-1)';
            one = ones(size(n));
            zero = zeros(size(n));
            r = [zero, one, n];
        end
        
        function nrm2=sqnorm(~, n)
            % SQNORM Compute the square norm of the Hermite polynomials.
            %
            % References:
            %   [1] http://dlmf.nist.gov/18.3.T1
            %
            % See also POLYNOMIALSYSTEM.SQNORM
            nrm2 = factorial(n);
        end
        
        function dist=weighting_dist(~)
            % WEIGHTING_DIST Return a distribution wrt to which the Hermite polynomials are orthogonal.
            %   DIST=WEIGHTING_DIST(POLYSYS) returns the a standard normal
            %   distribution, i.e. NormalDistribution(0,1).
            %   
            % See also DISTRIBUTION POLYNOMIALSYSTEM.WEIGHTING_DIST
            dist = NormalDistribution(0,1);
        end
    end
end
