classdef Distribution % < handle
    % DISTRIBUTION Abstract base class for probability distribution objects.
    %
    % See also BETADISTRIBUTION
    methods (Abstract)
        y=pdf(dist, x); % PDF Compute the probability distribution function.
        y=cdf(dist, x); % CDF Compute the cumulative distribution function.
        x=invcdf(dist, y); % INVCDF Compute the inverse CDF function.
        y=moments(dist); % MOMENTS Compute the moments of the distribution.
        str=tostring(dist); % TOSTRING Creates a string with a short diplay of the distribution properties
    end
    
    methods
        function mean=mean(dist)
            % MEAN computes the mean value of the distribution.
            mean=moments(dist);
        end
        
        function var=var(dist)
            % VAR computes the variance of the distribution
            [~,v]=dist.moments();
            var=v;
        end
        
        function tdist=translate(dist,shift,scale)
            % TRANSLATE translates the distribution DIST
            % TDIST=TRANSLATE(DIST,SHIFT,SCALE) translates the distribution
            % DIST in regard to parameters SHIFT and SCALE
            tdist=TranslatedDistribution(dist,shift,scale);
        end
        
        function new_dist=fix_moments(dist,mean,var)
            % FIX_MOMENTS Generates a new dist with specified moments.
            % NEW_DIST=FIX_MOMENTS(DIST, MEAN, VAR) computes from the
            % distribution DIST a new shifted and scaled distribution
            % NEW_DIST such that the mean and variance of NEW_DIST are
            % given by MEAN and VAR.
            [old_mean, old_var]=moments( dist );
            shift=mean-old_mean;
            scale=sqrt(var/old_var);
            new_dist=translate(dist,shift,scale);
        end
        
        function new_dist= fix_bounds(dist,min, max,varargin)
            % reads the user option or return the default in varargin.
            % If DIST is an unbounded distribution the options 'q0' and or
            % 'q1' can be set. Then the Q0 quantile of the new distribution
            % will be MIN and the Q1 quantile will be MAX (see Example 2).
            % If these options are not set, they default to 0 and 1, which
            % means the bounds of the distribution.
            
            options=varargin2options(varargin);
            [q0,options]=get_option(options,'q0',0);
            [q1,options]=get_option(options,'q1',1);
            check_unsupported_options(options,mfilename);
            
            % check bounds for the lower and upper quantiles (q0 and q1)
            check_range(q0, 0, 1, 'q0', mfilename);
            check_range(q1, q0, 1, 'q1', mfilename);
            
            % get the x values corresponding to the quantiles
            old_min=invcdf( dist,q0 );
            old_max=invcdf( dist,q1 );
            
            % check that the min and max are finite (i.e. either it was a
            %  bounded distribution or quantiles are different from 0 or 1)
            if ~isfinite(old_min)
                error('sglib:statistics', 'Lower quantile (q0) gives infinity (unbounded distribution?)');
            end
            if ~isfinite(old_max)
                error('sglib:statistics', 'Upper quantile (q1) gives infinity (unbounded distribution?)');
            end
            
            % Get the new scale and shift factors (just a linear mapping,
            % only the shift is a bit tricky since the mean needs to be
            % taken into account. BTW: it doesn't make a difference whether
            % the min or the max is used for the shift calculation)
            center = mean(dist);
            scale  = ((max-min) / (old_max-old_min));
            shift  = min - ((old_min-center)*scale + center);
            new_dist=translate(dist,shift,scale);
        end
        
        function y=stdnor(dist, x)
            % STDNOR Map normal distributed random values.
            % Y=STDNOR(DIST, X) Map normal distributed random values X to
            % random values Y distribution according to the probability
            % distribution DIST.
            y=dist.invcdf( normal_cdf( x ) );
        end
        
        function y=NORTA(dist, x)
            % NORTA Map normal distributed random values.
            % Y=NORTA(DIST, X) same as STDNOR.
            y=stdnor(dist, x);
        end
        
    end
    
    methods
        function polysys=default_sys_letter(dist, is_normalized)
            % DEFAULT_POLYSYS gives the 'natural' polynomial system
            % belonging to the distribution
            if nargin>=2 && is_normalized
                polysys='h';
            else
                polysys='H';
            end
        end
        
        function polys=default_polys(dist, is_normalized)
            % DEFAULT_POLYSYS gives the 'natural' polynomial system
            % belonging to the distribution
            if nargin<2;
                is_normalized=false;
            end
            polys=HermitePolynomials(is_normalized);
        end
    end
    
    
end
