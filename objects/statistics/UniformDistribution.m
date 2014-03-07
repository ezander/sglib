classdef UniformDistribution < Distribution
% UNIFORMDISTRIBUTION Short description of UniformDistribution.
%   UNIFORMDISTRIBUTION Long description of UniformDistribution.

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
        % a & b are the parameters of the Uniform Distribution
        a
        b
    end
    methods
        function obj=UniformDistribution(a,b)
            if nargin<1
                a=0;
            end
            if nargin<2
                b=1;
            end
               
            obj.a=a;
            obj.b=b;
        end
        
        function y=pdf(obj,x)
            % PDF Compute the probability distribution function of the Uniform distribution.
            y=uniform_pdf( x, obj.a, obj.b );
        end
        function y=cdf(obj,x)
            % CDF Compute the cumulative distribution function of the Uniform distribution.
            y=uniform_cdf( x, obj.a, obj.b );
        end
        function x=invcdf(obj,y)
            % INVCDF Compute the inverse CDF (or quantile) function of the Uniform distribution.
            x=uniform_invcdf( y, obj.a, obj.b );
        end
        function [var,mean,skew,kurt]=moments(obj)
            % MOMENTS Compute the moments of the Uniform distribution.
            [var,mean,skew,kurt]=uniform_moments( obj.a, obj.b );
        end
        function y=stdnor(dist, x)
            % STDNOR Map normal distributed random values.
            %   Y=STDNOR(DIST, X) Map normal distributed random values X to random
            %   values Y distribution according to the probability distribution DIST.
            y=dist.invcdf( normal_cdf( x ) );
        end
        
    end
end
