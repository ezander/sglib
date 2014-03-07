classdef BetaDistribution < Distribution
    properties 
        % The parameter A of the Beta(A,b) distribution
        a
        % The parameter B of the Beta(a,B) distribution
        b
    end
    methods
        function obj=BetaDistribution(a,b)
            % BETADISTRIBUTION Construct a BetaDistribution.
            %   OBJ=BETADISTRIBUTION(A,B) constructs an object returned in
            %   OBJ representing a Beta distribution with parameters A and B.
            obj.a=a;
            obj.b=b;
        end
        
        function y=pdf(obj,x)
            % PDF Compute the probability distribution function of the Beta distribution.
            y=beta_pdf( x, obj.a, obj.b );
        end
        function y=cdf(obj,x)
            % CDF Compute the cumulative distribution function of the Beta distribution.
            y=beta_cdf( x, obj.a, obj.b );
        end
        function x=invcdf(obj,y)
            % INVCDF Compute the inverse CDF (or quantile) function of the Beta distribution.
            x=beta_invcdf( y, obj.a, obj.b );
        end
        function [var,mean,skew,kurt]=moments(obj)
            % MOMENTS Compute the moments of the Beta distribution.
            [var,mean,skew,kurt]=beta_moments( obj.a, obj.b );
        end
        function y=stdnor(dist, x)
            % STDNOR Map normal distributed random values.
            %   Y=STDNOR(DIST, X) Map normal distributed random values X to random
            %   values Y distribution according to the probability distribution DIST.
            y=dist.invcdf( normal_cdf( x ) );
        end
        
    end
end