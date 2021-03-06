classdef ChebyshevTPolynomials < PolynomialSystem
    % CHEBYSHEVTPOLYNOMIALS Constructs a ChebyshevTPolynomials.
    %
    % Example (<a href="matlab:run_example ChebyshevTPolynomials">run</a>)
    %   polysys=ChebyshevTPolynomials();
    %   x=linspace(-1,1);
    %   y=polysys.evaluate(4, x);
    %   plot(x,y);
    %
    % See also LEGENDREPOLYNOMIALS LAGUERREPOLYNOMIALS
    
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
        function polysys=ChebyshevTPolynomials()
            % CHEBYSHEVTPOLYNOMIALS Construct the ChebyshevTPolynomials.
            %   POLYSYS=CHEBYSHEVTPOLYNOMIALS() constructs a polynomial system
            %   returned in polysys, representing Chebyshev polynomials of the
            %   1st kind.
        end
        
        function r=recur_coeff(~, deg)
            % RECUR_COEFF Compute recurrence coefficient of orthogonal polynomials.
            % References:
            %   [1] Abramowitz & Stegun: Handbook of Mathematical Functions
            %   [2] http://dlmf.nist.gov/18.9
            n = (0:deg-1)';
            one = ones(size(n));
            zero = zeros(size(n));
            r = [zero, 2*one - (n==0), one];
        end
        
        function nrm2 =sqnorm(~, n)
            % SQNORM Compute the square norm of the Chebyshev T polynomials.
            %
            % References:
            %   [1] http://dlmf.nist.gov/18.3.T1
            %
            % See also POLYNOMIALSYSTEM.SQNORM
            nrm2 = 0.5*((n==0) + 1);
        end
        
        function dist=weighting_dist(~)
            % WEIGHTING_DIST Return a distribution wrt to which the Hermite polynomials are orthogonal.
            %   DIST=WEIGHTING_DIST(POLYSYS) returns the a standard normal
            %   distribution, i.e. NormalDistribution(0,1).
            %   
            % See also DISTRIBUTION POLYNOMIALSYSTEM.WEIGHTING_DIST
            dist = ArcSinDistribution();
        end
    end
end
