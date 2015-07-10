classdef LogNormalDistribution < Distribution
    % LOGNORMALDISTRIBUTION Construct a LogNormalDistribution.
    %   DIST=LOGNORMALDISTRIBUTION(MU,SIGMA) constructs a distribution
    %   returned in DIST representing a LogNormal distribution with
    %   parameters MU and SIGMA.
    %
    % Example (<a href="matlab:run_example LogNormalDistribution">run</a>)
    %   dist = LogNormalDistribution(2,3);
    %   [mean,var,skew,kurt]=dist.moments()
    %
    % See also DISTRIBUTION NORMALDISTRIBUTION BEA_PDF
    
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
        % The parameter MU of the LogNormal(MU,sigma) distribution. MU is
        % the location parameter.
        mu
        
        % The parameter SIGMA of the LogNormal(mu,SIGMA) distribution.
        % SIGMA is the scale parameter.
        sigma
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
    end
end
