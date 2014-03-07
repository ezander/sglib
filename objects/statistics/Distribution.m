classdef Distribution % < handle
    % DISTRIBUTION Abstract base class for probability distribution objects.
    %
    % See also BETADISTRIBUTION
    methods (Abstract)
        y=pdf(dist, x); % PDF Compute the probability distribution function.
        y=cdf(dist, x); % CDF Compute the cumulative distribution function.
        x=invcdf(dist, y); % INVCDF Compute the inverse CDF (or quantile) function.
        y=moments(dist); % MOMENTS Compute the moments of the distribution.
    end
    methods
        function y=stdnor(dist, x)
            % STDNOR Map normal distributed random values.
            %   Y=STDNOR(DIST, X) Map normal distributed random values X to random
            %   values Y distribution according to the probability distribution DIST.
            y=dist.invcdf( normal_cdf( x ) );
        end
    end
end
