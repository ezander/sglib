classdef LogNormalDistribution < Distribution
    % LOGNORMALDISTRIBUTION Construct a LogNormalDistribution.
    %   DIST=LOGNORMALDISTRIBUTION(MU,SIGMA) constructs a distribution
    %   returned in DIST representing a LogNormal distribution with
    %   parameters MU and SIGMA.
    %
    % Example (<a href="matlab:run_example LogNormalDistribution">run</a>)
    %   dist = LogNormalDistribution(1.2,0.4);
    %   [mean,var,skew,kurt]=dist.moments()
    %
    %   x = dist.invcdf(linspace(0,0.999,10000));
    %   plot(x, dist.pdf(x));
    %
    % See also DISTRIBUTION NORMALDISTRIBUTION BEA_PDF
    
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
    
    properties
        % The parameter MU of the LogNormal(MU,sigma) distribution. MU is
        % the location parameter.
        mu
        
        % The parameter SIGMA of the LogNormal(mu,SIGMA) distribution.
        % SIGMA is the scale parameter.
        sigma
    end
    
    methods
        function str=tostring(dist)
            % Displays the distribution type: 'lnN(mu, var)'
            str=sprintf('lnN(%g, %g)', dist.mu, dist.sigma^2);
        end
    end
    
    methods
        function dist=LogNormalDistribution(mu,sigma)
            % LOGNORMALDISTRIBUTION Construct a LogNormalDistribution.
            % DIST=LOGNORMALDISTRIBUTION(MU,SIGMA) constructs a distribution
            % returned in DIST representing a LogNormal distribution with
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
            % LogNormal distribution.
            y=lognormal_pdf( x, dist.mu, dist.sigma );
        end
        
        function y=cdf(dist,x)
            % CDF computes the cumulative distribution function of the
            % LogNormal distribution.
            y=lognormal_cdf( x, dist.mu, dist.sigma );
        end
        
        function x=invcdf(dist,y)
            % INVCDF computes the inverse CDF (or quantile) function of the
            % LogNormal distribution.
            x=lognormal_invcdf( y, dist.mu, dist.sigma );
        end
        
        function [mean,var,skew,kurt]=moments(dist)
            % MOMENTS computes the moments of the LogNormal distribution.
            m = {nan, nan, nan, nan};
            [m{1:nargout}] = lognormal_moments( dist.mu, dist.sigma );
            [mean,var,skew,kurt]=deal(m{:});
        end
        
        function xi=sample(dist,n)
            %   Draw random samples from LogNormal distribution.
            %   XI=SAMPLE(DIST,N) draws N random samples from the random
            %   distribution DIST. If N is a scalar value XI is a column vector of
            %   random samples of size [N,1]. If N is a vector XI is a matrix (or
            %   tensor) of size [N(1), N(2), ...].
            xi=lognormal_sample(n, dist.mu, dist.sigma);
        end
    end
    
    methods
        function base=get_base_dist(~)
            % Get base distribution (corresponding to standard distribution
            % in the gpc, for which the default polynomial system is orthogonal)
            base=NormalDistribution(0,1);
        end
        
        function x=base2dist(dist,y)
            % Get mapping from base distribution (corresponding to standard distribution
            % in the gpc, for which the default polynomial system is
            % orthogonal) to the actual distribution
            x=exp(y*dist.sigma+dist.mu);
        end
        
        function y=dist2base(dist,x)
            % Get mapping from base distribution (corresponding to standard distribution
            % in the gpc, for which the default polynomial system is
            % orthogonal) to the actual distribution
            y=(log(x)-dist.mu)/dist.sigma;
        end
        function x=stdnor(dist,y)
            % STDNOR Map from normal distributed random values.
            % Y=STDNOR(DIST, X) Map normal distributed random values X to
            % random values Y distribution according to the probability
            % distribution DIST.
            x=base2dist(dist,y);
        end
        function y=dist2stdnor(dist, x)
            % DIST2STDNOR Map from random values Y, with distribution according 
            % to the probability distribution DIST., to random values X with
            % standard normal distributed random values.
            % X=DIST2STDNOR(DIST, Y). This is the inverse map of
            % STDNOR
            % 
            y=dist2base(dist,x);
        end
    end
end
