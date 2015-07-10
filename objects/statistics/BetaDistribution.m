classdef BetaDistribution < Distribution
    % BETADISTRIBUTION Construct a BetaDistribution.
    %   DIST=BETADISTRIBUTION(A,B) constructs a distribution returned in
    %   DIST representing a beta distribution with parameters A and B.
    %
    % Example (<a href="matlab:run_example BetaDistribution">run</a>)
    %   dist = BetaDistribution(2,3);
    %   [mean,var,skew,kurt]=dist.moments()
    %
    % See also DISTRIBUTION NORMALDISTRIBUTION BETA_PDF
    
    %   Aidin Nojavan
    %   Copyright 2014, Inst. of Scientific Computing, TU Braunschweig
    %
    %   This program is free software: you can redistribute it and/or
    %   modify it under the terms of the GNU General Public License as
    %   published by the Free Software Foundation, either version 3 of the
    %   License, or (at your option) any later version.
    %   See the GNU General Public License for more details. You should
    %   have received a copy of the GNU General Public License along with
    %   this program.  If not, see <http://www.gnu.org/licenses/>.
    
    properties
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
            y=beta_pdf( x, dist.a, dist.b );
        end
        function y=cdf(dist,x)
            % CDF computes the cumulative distribution function of the beta
            % distribution.
            y=beta_cdf( x, dist.a, dist.b );
        end
        function x=invcdf(dist,y)
            % INVCDF computes the inverse CDF (or quantile) function of the
            % beta distribution.
            x=beta_invcdf( y, dist.a, dist.b );
        end
        function [mean,var,skew,kurt]=moments(dist)
            % MOMENTS computes the moments of the beta distribution.
            m = {nan, nan, nan, nan};
            [m{1:nargout}] = beta_moments( dist.a, dist.b );
            [mean,var,skew,kurt]=deal(m{:});
        end
    end
end