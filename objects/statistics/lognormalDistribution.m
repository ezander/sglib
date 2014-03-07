classdef lognormalDistribution < Distribution
% LOGNORMALDISTRIBUTION Short description of lognormalDistribution.
%   LOGNORMALDISTRIBUTION Long description of lognormalDistribution.
%
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
        % mu & sigma are the parameters of the lognormal Distribution
        mu
        sigma
    end
    methods
        function obj=lognormalDistribution(mu,sigma)
            obj.mu=mu;
            obj.sigma=sigma;
        end
        
        function y=pdf(obj,x)
            % PDF Compute the probability distribution function of the lognormal distribution.
            y=lognormal_pdf( x, obj.mu, obj.sigma );
        end
        function y=cdf(obj,x)
            % CDF Compute the cumulative distribution function of the lognormal distribution.
            y=lognormal_cdf( x, obj.mu, obj.sigma );
        end
        function x=invcdf(obj,y)
            % INVCDF Compute the inverse CDF (or quantile) function of the lognormal distribution.
            x=lognormal_invcdf( y, obj.sigma, obj.sigma );
        end
        function [var,mean,skew,kurt]=moments(obj)
            % MOMENTS Compute the moments of the lognormal distribution.
            [var,mean,skew,kurt]=lognormal_moments( obj.sigma, obj.sigma );
        end
        function y=stdnor(dist, x)
            % STDNOR Map normal distributed random values.
            %   Y=STDNOR(DIST, X) Map normal distributed random values X to random
            %   values Y distribution according to the probability distribution DIST.
            y=dist.invcdf( normal_cdf( x ) );
        end
        
    end
end
