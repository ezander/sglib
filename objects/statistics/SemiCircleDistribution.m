classdef SemiCircleDistribution < BetaDistribution
    % SEMICIRCLEDISTRIBUTION Construct a BetaDistribution.
    %   DIST=SEMICIRCLEDISTRIBUTION() constructs a beta distribution returned in
    %   DIST representing a beta distribution with parameters A=3/2 and
    %   B=3/2shifted to have bounds [a,b]
    %
    % Example (<a href="matlab:run_example SemiCircleDistribution">run</a>)
    %   dist = SemiCircleDistribution();
    %   [mean,var,skew,kurt]=dist.moments()
    %
    %   x = dist.invcdf(linspace(0,1));
    %   plot(x, dist.pdf(x));
    %
    % See also DISTRIBUTION BETADISTRIBUTION BETA_PDF
    
    %   Noemi Friedman, Elmar Zander
    %   Copyright 2015, Inst. of Scientific Computing, TU Braunschweig
    %
    %   This program is free software: you can redistribute it and/or
    %   modify it under the terms of the GNU General Public License as
    %   published by the Free Software Foundation, either version 3 of the
    %   License, or (at your option) any later version.
    %   See the GNU General Public License for more details. You should
    %   have received a copy of the GNU General Public License along with
    %   this program.  If not, see <http://www.gnu.org/licenses/>.
    
    methods
        function dist = SemiCircleDistribution()
            dist@BetaDistribution(3/2, 3/2);
        end
        
        function str=tostring(dist) %#ok<MANU>
            % TOSTRING Displays the distribution type.
            str=sprintf('SemiCircle()');
        end
    end
    
    methods
        function polysys=orth_polysys(~)
            % ORTH_POLYSYS returns the orthogonal polynomials for the SemiCircle distribution.
            %   POLYSYS=ORTH_POLYSYS(DIST) returns the Chebyshev U
            %   polynomials.
            %
            % See also CHEBYSHEVUPOLYNOMIALS DISTRIBUTION.ORTH_POLYSYS DISTRIBUTION.GET_BASE_DIST
            
            polysys=ChebyshevUPolynomials();
        end
    end
end
