classdef ArcSinDistribution < BetaDistribution
    % ARCSINDISTRIBUTION Construct a BetaDistribution.
    %   DIST=ARCSINDISTRIBUTION() constructs a beta distribution returned in
    %   DIST representing a beta distribution with parameters A=3/2 and
    %   B=3/2 shifted to have bounds [a,b]
    %
    % Example (<a href="matlab:run_example ArcSinDistribution">run</a>)
    %   dist = ArcSinDistribution();
    %   [mean,var,skew,kurt]=dist.moments()
    %
    %   x = dist.invcdf(linspace(0.01,0.99,10000));
    %   plot(x, dist.pdf(x));
    %   ylim([0, 5]);
    %
    % See also DISTRIBUTION BETADISTRIBUTION NORMALDISTRIBUTION BETA_PDF
    
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
        function dist = ArcSinDistribution()
            dist@BetaDistribution(1/2, 1/2);
        end
        
        function str=tostring(dist) %#ok<MANU>
            % TOSTRING Displays the distribution type.
            str=sprintf('ArcSin()');
        end
    end
    
    methods
        function polysys=orth_polysys(~)
            % ORTH_POLYSYS returns the orthogonal polynomials for the ArcSin distribution.
            %   POLYSYS=ORTH_POLYSYS(DIST) returns the Chebyshev T
            %   polynomials.
            % 
            % See also CHEBYSHEVTPOLYNOMIALS DISTRIBUTION.ORTH_POLYSYS DISTRIBUTION.GET_BASE_DIST
            
            polysys=ChebyshevTPolynomials();
        end
    end
end