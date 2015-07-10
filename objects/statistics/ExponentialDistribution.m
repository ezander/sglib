classdef ExponentialDistribution < Distribution
    % EXPONENTIALDISTRIBUTION Constructs an ExponentialDistribution.
    %   DIST=EXPONENTIALDISTRIBUTION(LAMBDA) constructs a distribution
    %   returned in dist representing an exponential distribution
    %   with parameter LAMBDA.
    %
    % Example (<a href="matlab:run_example ExponentialDistribution">run</a>)
    %   dist = ExponentialDistribution(2);
    %   [mean,var,skew,kurt]=dist.moments()
    %
    % See also DISTRIBUTION LOGNORMALDISTRIBUTION BETA_CDF
    
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
        % The parameter LAMBDA of the Exponential(LAMBDA) distribution.
        % LAMBDA is the parameter of the exponential distribution (rate
        % parameter)
        lambda
    end
    methods
        function dist=ExponentialDistribution(lambda)
            % EXPONENTIALDISTRIBUTION Constructs an ExponentialDistribution.
            % DIST=EXPONENTIALDISTRIBUTION(LAMBDA) constructs a distribution
            % returned in dist representing an exponential distribution
            % with parameter LAMBDA.
            dist.lambda=lambda;
        end
        function y=pdf(dist,x)
            % PDF computes the probability distribution function of the
            % exponential distribution.
            y=exponential_pdf( x, dist.lambda);
        end
        function y=cdf(dist,x)
            % CDF computes the cumulative distribution function of the
            % exponential distribution.
            y=exponential_cdf( x, dist.lambda);
        end
        function x=invcdf(dist,y)
            % INVCDF computes the inverse CDF (or quantile) function of the
            % exponential distribution.
            x=exponential_invcdf( y, dist.lambda );
        end
        function [mean,var,skew,kurt]=moments(dist)
            % MOMENTS computes the moments of the exponential distribution.
            m = {nan, nan, nan, nan};
            [m{1:nargout}] = exponential_moments( dist.lambda );
            [mean,var,skew,kurt]=deal(m{:});
        end
    end
end

