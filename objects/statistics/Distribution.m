classdef Distribution < SglibObject
    % DISTRIBUTION Abstract base class for probability distribution objects.
    %
    % See also BETADISTRIBUTION
    methods (Abstract)
        y=pdf(dist, x); % PDF Compute the probability distribution function.
        y=cdf(dist, x); % CDF Compute the cumulative distribution function.
        x=invcdf(dist, y); % INVCDF Compute the inverse CDF function.
        y=moments(dist); % MOMENTS Compute the moments of the distribution.
    end
    
    %% Basic distribution methods
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
        
        function xi=sample(dist,n)
            % SAMPLE Draw random samples from this distribution.
            %   XI=SAMPLE(DIST, N) draws N random samples from the random
            %   distribution DIST. If N is a scalar value XI is a column
            %   vector of random samples of size [N,1]. If N is a vector XI
            %   is a matrix (or tensor) of size [N(1), N(2), ...].
            yi = uniform_sample(n, 0, 1);
            xi = dist.invcdf(yi);
        end
    end
    
    %% Methods related to translation/scaling of the distribution
    methods
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
    end
    
    methods
        function y=stdnor(dist, x)
            % STDNOR Map from normal distributed random values.
            % Y=STDNOR(DIST, X) Map normal distributed random values X to
            % random values Y distribution according to the probability
            % distribution DIST.
            y=dist.invcdf( normal_cdf( x ) );
        end
        function x=dist2stdnor(dist, y)
            % DIST2STDNOR Map from random values Y, with distribution according 
            % to the probability distribution DIST., to random values X with
            % standard normal distributed random values.
            % X=DIST2STDNOR(DIST, Y). This is the inverse map of
            % STDNOR
            % 
            x=normal_invcdf(dist.cdf( y ) );
        end
    end
    
    methods
        function dist_germ=get_base_dist(~)
            % Get base distribution (corresponding to standard distribution
            % in the gpc, for which the default polynomial system is orthogonal)
            dist_germ=NormalDistribution(0,1);
        end
        
        function x=base2dist(dist,y)
            % Get mapping from base distribution (corresponding to standard distribution
            % in the gpc, for which the default polynomial system is
            % orthogonal) to the actual distribution
            x=dist.invcdf (dist.get_base_dist.cdf(y));
        end
        
        function y=dist2base(dist, x)
            % Get mapping from base distribution (corresponding to standard distribution
            % in the gpc, for which the default polynomial system is
            % orthogonal) to the actual distribution
            y=dist.get_base_dist.invcdf(dist.cdf( x));
        end
        
        function polysys=orth_polysys(dist) %#ok<STOUT>
            % ORTH_POLYSYS gives the polynomial system which is orthogonal
            % with respect to this distribution. This function should
            % return only a polynomial system, if a) the polynomials are
            % dense (wrt. to the weighted L2) and b) the DIST
            % corresponds to the "standard form" for this distribution,
            % i.e. for example N(0,1), but not N(2, 4). In the latter case,
            % one would have to call DIST.GET_BASE_DIST first.
            % 
            % See also DISTRIBUTION.GET_BASE_DIST
            error('sglib:distribution:no_polysys', 'No polynomials system for this distribution (%s)', dist.tostring());
        end
        
        function polysys=default_polysys(dist, is_normalized)
            polysys = dist.orth_polysys();
            if is_normalized
                polysys = polysys.normalized();
            end
        end
    end
end
