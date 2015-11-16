classdef LaguerrePolynomials < PolynomialSystem
    % LAGUERREPOLYNOMIALS Construct the LaguerrePolynomials.
    %
    % Example (<a href="matlab:run_example LaguerrePolynomials">run</a>)
    %   poly=LaguerrePolynomials();
    %   x=linspace(-5,20);
    %   y=poly.evaluate(5, x);
    %   plot(x,y);
    %   ylim([-10, 20]);
    %
    % See also POLYNOMIALSYSTEM HERMITEPOLYNOMIALS
    
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
    properties
    end
    
    methods
        function sys=LaguerrePolynomials()
            % LAGUERREPOLYNOMIALS Construct the LaguerrePolynomials.
            %   POLY=LAGUERREPOLYNOMIALS() constructs a polynomial system
            %   representing the Laguerre polynomials.
        end
        
        function r=recur_coeff(~, deg)
            % RECUR_COEFF Compute recurrence coefficient of Laguerre polynomials.
            %
            % References:
            %   [1] http://dlmf.nist.gov/18.9.i
            %
            % See also POLYNOMIALSYSTEM.RECUR_COEFF
            n = (0:deg-1)';
            r = [(2*n + 1) ./ (n+1),  -1 ./ (n+1), n ./ (n+1)];
        end
        
        function nrm2=sqnorm(~, n)
            % SQNORM Compute the square norm of the Laguerre polynomials.
            %   Note: the Laguerre polynomials are already normalized in
            %   their standard form.
            %
            % References:
            %   [1] http://dlmf.nist.gov/18.3.T1
            %
            % See also POLYNOMIALSYSTEM.SQNORM
            nrm2 = ones(size(n));
        end
        
        function poly=normalized(poly)
            % NORMALIZED Return a normalized version of the Laguerre polynomials
            %   Needs to do nothing in this case, as the Laguerres are
            %   already normalized.
            %
            % See also POLYNOMIALSYSTEM.NORMALIZED SQNORM
        end
        
        %         function w_dist=weighting_func()
        %             %w_dist=ExponentialDistribution(1);
        %             w_dist= gendist_create('exponential', {1});
        %         end
    end
end
