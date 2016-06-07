classdef BetaDistribution < Distribution
    % BETADISTRIBUTION Construct a BetaDistribution.
    %   DIST=BETADISTRIBUTION(A,B) constructs a distribution returned in
    %   DIST representing a beta distribution with parameters A and B.
    %
    % Example (<a href="matlab:run_example BetaDistribution">run</a>)
    %   dist = BetaDistribution(2,3);
    %   [mean,var,skew,kurt]=dist.moments()
    %
    %   x = dist.invcdf(linspace(0,1,10000));
    %   plot(x, dist.pdf(x));
    %
    % See also DISTRIBUTION NORMALDISTRIBUTION BETA_PDF
    
    %   Elmar Zander, Aidin Nojavan, Noemi Friedman
    %   Copyright 2014, Inst. of Scientific Computing, TU Braunschweig
    %
    %   This program is free software: you can redistribute it and/or
    %   modify it under the terms of the GNU General Public License as
    %   published by the Free Software Foundation, either version 3 of the
    %   License, or (at your option) any later version.
    %   See the GNU General Public License for more details. You should
    %   have received a copy of the GNU General Public License along with
    %   this program.  If not, see <http://www.gnu.org/licenses/>.
    
    properties (SetAccess=protected)
        % The parameter A of the Beta(A,b) distribution. A is a positive
        % shape parameter, that appears as exponent of the random
        % variable and controls the shape of the distribution
        a
        % The parameter B of the Beta(a,B) distribution.  B is a positive
        % shape parameter, that appears as exponent of the random
        % variable and controls the shape of the distribution
        b
    end
    
    methods
        function dist=BetaDistribution(a,b)
            % BETADISTRIBUTION Construct a BetaDistribution.
            % DIST=BETADISTRIBUTION(A,B) constructs a distribution returned
            % in DIST representing a beta distribution with parameters A
            % and B.
            dist.a=a;
            dist.b=b;
        end
        
        function y=pdf(dist,x)
            % PDF computes the probability distribution function of the
            % beta distribution.
            x=TranslatedDistribution.translate_points_backwards(x, -1, 2, 0);
            y=beta_pdf( x, dist.a, dist.b ) / 2;
        end
        
        function y=cdf(dist,x)
            % CDF computes the cumulative distribution function of the beta
            % distribution.
            x=TranslatedDistribution.translate_points_backwards(x, -1, 2, 0);
            y=beta_cdf( x, dist.a, dist.b );
        end
        
        function x=invcdf(dist,y)
            % INVCDF computes the inverse CDF (or quantile) function of the
            % beta distribution.
            x=beta_invcdf( y, dist.a, dist.b );
            x=TranslatedDistribution.translate_points_forward(x, -1, 2, 0);
        end
        
        function [mean,var,skew,kurt]=moments(dist)
            % MOMENTS computes the moments of the beta distribution.
            m = {nan, nan, nan, nan};
            [m{1:nargout}] = beta_moments( dist.a, dist.b );
            m=TranslatedDistribution.translate_moments(m, -1, 2, 0);
            [mean,var,skew,kurt]=deal(m{:});
        end
        
        function str=tostring(dist)
            % Displays the distribution type: 'Beta(a, b)'
            str=sprintf('Beta(%g, %g)', dist.a, dist.b);
        end
    end
    
    methods
        function polysys=orth_polysys(dist)
            % ORTH_POLYSYS returns the orthogonal polynomials for the SemiCircle distribution.
            %   POLYSYS=ORTH_POLYSYS(DIST) returns the Chebyshev U
            %   polynomials.
            %
            % See also CHEBYSHEVUPOLYNOMIALS DISTRIBUTION.ORTH_POLYSYS DISTRIBUTION.GET_BASE_DIST

            polysys=JacobiPolynomials(dist.b-1, dist.a-1);
        end
    end
    
    methods
        function dist_germ=get_base_dist(dist)
            % Get base distribution (corresponding to standard distribution
            % in the gpc, for which the default polynomial system is orthogonal)
            dist_germ=dist;
        end
        
        function x=base2dist(~, y)
            % Get mapping from base distribution (corresponding to standard distribution
            % in the gpc, for which the default polynomial system is
            % orthogonal) to the actual distribution
            x=y;
        end
        
        function y=dist2base(~, x)
            % Get mapping from base distribution (corresponding to standard distribution
            % in the gpc, for which the default polynomial system is
            % orthogonal) to the actual distribution
            y=x;
        end
    end
end
