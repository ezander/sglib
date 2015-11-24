classdef NormalDistribution < Distribution
    % NORMALDISTRIBUTION Construct a NormalDistribution.
    %   DIST=NORMALDISTRIBUTION(MU,SIGMA) constructs a distribution
    %   returned in DIST representing a normal distribution with
    %   parameters MU and SIGMA.
    %
    % Example (<a href="matlab:run_example NormalDistribution">run</a>)
    %   dist = NormalDistribution(2,3);
    %   [mean,var,skew,kurt]=dist.moments()
    %
    % See also DISTRIBUTION LOGNORMALDISTRIBUTION BETA_CDF
    
    %   Elmar Zander, Aidin Nojavan
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
        % The parameter MU of the Normal(MU,sigma) distribution. MU is
        % the mean value.
        mu
        
        % The parameter SIGMA of the Normal(mu,SIGMA) distribution. SIGMA
        % is the variance value.
        sigma
    end
    
    methods
        function str=tostring(dist)
            % Displays the distribution type: 'N(mu,var)'
            str=sprintf('N(%g, %g)', dist.mu, dist.sigma^2);
        end
    end
        
    methods
        function dist=NormalDistribution(mu,sigma)
            % NORMALDISTRIBUTION Constructs a NormalDistribution.
            % DIST=NORMALDISTRIBUTION(MU,SIGMA) constructs a distribution
            % returned in DIST representing a normal distribution with
            % parameters MU and SIGMA.
            
            % Default parameters
            if nargin<1
                mu=0;
            end
            if nargin<2
                sigma=1;
            end
            dist.mu=mu;
            dist.sigma=sigma;
        end
        
        function y=pdf(dist,x)
            % PDF computes the probability distribution function of the
            % normal distribution.
            y=normal_pdf( x, dist.mu, dist.sigma );
        end
        
        function y=cdf(dist,x)
            % CDF computes the cumulative distribution function of the
            % normal distribution.
            y=normal_cdf( x, dist.mu, dist.sigma );
        end
        
        function x=invcdf(dist,y)
            % INVCDF computes the inverse CDF (or quantile) function of the
            % normal distribution.
            x=normal_invcdf( y, dist.mu, dist.sigma );
        end
        
        function [mean,var,skew,kurt]=moments(dist)
            % MOMENTS computes the moments of the normal distribution.
            m = {nan, nan, nan, nan};
            [m{1:nargout}] = normal_moments( dist.mu, dist.sigma );
            [mean,var,skew,kurt]=deal(m{:});
        end
        
        function xi=sample(dist,n)
            %   Draw random samples from Normal distribution.
            %   XI=SAMPLE(DIST,N) draws N random samples from the random
            %   distribution DIST. If N is a scalar value XI is a column vector of
            %   random samples of size [N,1]. If N is a vector XI is a matrix (or
            %   tensor) of size [N(1), N(2), ...].
            xi=normal_sample(n, dist.mu, dist.sigma);
        end
    end
    
    methods
        function new_dist=translate(dist,shift,scale)
            % TRANSLATE translates the normal distribution DIST
            % NEW_DIST=TRANSLATE(DIST,SHIFT,SCALE) translates the normal
            % distribution DIST in regard to parameters SHIFT and SCALE
            new_dist=NormalDistribution(dist.mu+shift,dist.sigma*scale);
        end
    end
    
    methods
        function polysys=orth_polysys(dist)
            % ORTH_POLYSYS returns the orthogonal polynomials for the Normal distribution.
            %   POLYSYS=ORTH_POLYSYS(DIST) returns Hermite polynomials.
            %
            % See also HERMITEPOLYNOMIALS DISTRIBUTION.ORTH_POLYSYS DISTRIBUTION.GET_BASE_DIST
            if dist.mu==0 && dist.sigma==1
                polysys=HermitePolynomials();
            else
                % This should throw an error.
                polysys=dist.orth_polysys@Distribution();
            end
        end
        
        function dist_germ=get_base_dist(~)
            % Get base distribution (corresponding to standard distribution
            % in the gpc, for which the default polynomial system is orthogonal)
            dist_germ=NormalDistribution(0,1);
        end
        
        function y=base2dist(dist, x)
            % Get mapping from base distribution (corresponding to standard distribution
            % in the gpc, for which the default polynomial system is
            % orthogonal) to the actual distribution
             y = dist.mu+x*dist.sigma;
        end
        
        function x=dist2base(dist, y)
            % Get mapping from base distribution (corresponding to standard distribution
            % in the gpc, for which the default polynomial system is
            % orthogonal) to the actual distribution
            x = (y-dist.mu)/dist.sigma;
        end
    end
    
end
