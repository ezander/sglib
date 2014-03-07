classdef ExponentialDistribution < Distribution
% EXPONENTIALDISTRIBUTION Short description of ExponentialDistribution.
%   EXPONENTIALDISTRIBUTION Long description of ExponentialDistribution.
%
% Example (<a href="matlab:run_example ExponentialDistribution">run</a>)
%   dist = ExponentialDistribution(2);
%   [mu,var]=dist.moments()
%
% See also

%   Aidin Nojavan
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
        % lambda is the parameter of the Exponential Distribution (rate
        % parameter)
        lambda
    end
    methods
        function obj=ExponentialDistribution(lambda)
            obj.lambda=lambda;
        end
        
        function y=pdf(obj,x)
            % PDF Compute the probability distribution function of the Exponential distribution.
            y=exponential_pdf( x, obj.lambda);
        end
        function y=cdf(obj,x)
            % CDF Compute the cumulative distribution function of the Exponential distribution.
            y=exponential_cdf( x, obj.lambda);
        end
        function x=invcdf(obj,y)
            % INVCDF Compute the inverse CDF (or quantile) function of the Exponential distribution.
            x=exponential_invcdf( y, obj.lambda );
        end
        function [var,mean,skew,kurt]=moments(obj)
            % MOMENTS Compute the moments of the Exponential distribution.
            [var,mean,skew,kurt]=exponential_moments( obj.lambda);
        end
       
    end
end

