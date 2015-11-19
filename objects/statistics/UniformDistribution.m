classdef UniformDistribution < Distribution
    % UNIFORMDISTRIBUTION Constructs a UniformDistribution.
    %   DIST=UNIFORMDISTRIBUTION(A,B) constructs a distribution
    %   returned in DIST representing a uniform distribution with
    %   parameters A and B.
    %
    % Example (<a href="matlab:run_example UniformDistribution">run</a>)
    %   dist = LogNormalDistribution(2,3);
    %   [mean,var,skew,kurt]=dist.moments()
    %
    % See also DISTRIBUTION NORMALDISTRIBUTION BETA_PDF
    
    %   Aidin Nojavan  (slightly modified by Noemi Friedman)
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
        % The parameter A of the Uniform(A,b) distribution.
        a
        
        % The parameter B of the Uniform(a,B) distribution.
        b
    end
    
    methods
        function str=tostring(dist)
            % Displays the distribution type: 'U(a, b)'
            str=sprintf('U(%g, %g)', dist.a, dist.b);
        end
    end
    
    methods
        function dist=UniformDistribution(a,b)
            % UNIFORMDISTRIBUTION Constructs a UniformDistribution.
            % DIST=UNIFORMDISTRIBUTION(A,B) constructs a distribution
            % returned in DIST representing a uniform distribution with
            % parameters A and B.
            
            % Default parameters
            if nargin<1
                a=0;
            end
            if nargin<2
                b=1;
            end
            dist.a=a;
            dist.b=b;
        end
        function y=pdf(dist,x)
            % PDF compute the probability distribution function of the
            % uniform distribution.
            y=uniform_pdf( x, dist.a, dist.b );
        end
        function y=cdf(dist,x)
            % CDF compute the cumulative distribution function of the
            % uniform distribution.
            y=uniform_cdf( x, dist.a, dist.b );
        end
        function x=invcdf(dist,y)
            % INVCDF compute the inverse CDF (or quantile) function of the
            % uniform distribution.
            x=uniform_invcdf( y, dist.a, dist.b );
        end
        function [mean,var,skew,kurt]=moments(dist)
            % MOMENTS compute the moments of the uniform distribution.
            m = {nan, nan, nan, nan};
            [m{1:nargout}] = uniform_moments( dist.a, dist.b );
            [mean,var,skew,kurt]=deal(m{:});
        end
        function dist=translate(dist,shift,scale)
            % TRANSLATE translates the uniform distribution DIST
            % NEW_DIST=TRANSLATE(DIST,SHIFT,SCALE) translates the uniform
            % distribution DIST in regard to parameters SHIFT and SCALE
            m=(dist.a+dist.b)/2;
            v=scale*(dist.b-dist.a)/2;
            
            dist.a=m+shift-v;
            dist.b=m+shift+v;
        end
        
        function xi=sample(dist,n)
            %   Draw random samples from Uniform distribution.
            %   XI=SAMPLE(DIST,N) draws N random samples from the random
            %   distribution DIST. If N is a scalar value XI is a column vector of
            %   random samples of size [N,1]. If N is a vector XI is a matrix (or
            %   tensor) of size [N(1), N(2), ...].
            if isscalar(n)
                yi = rand(n,1);
            else
                yi = rand(n);
            end
            shift=(dist.a+dist.b)/2-(dist.b-dist.a)/2;
            scale=(dist.b-dist.a);
            xi =(yi *scale ) + shift;
        end
    end
    
    methods
        function dist_germ=get_base_dist(dist)
            % Get base distribution (corresponding to standard distribution
            % in the gpc, for which the default polynomial system is orthogonal)
            dist_germ=UniformDistribution(-1,1);
        end
        
        function x=base2dist(dist,y)
            % Get mapping from base distribution (corresponding to standard distribution
            % in the gpc, for which the default polynomial system is
            % orthogonal) to the actual distribution
            x=dist.mean+y*(dist.b-dist.a)/2;
        end
        
        function y=dist2base(dist,x)
            % Get mapping from base distribution (corresponding to standard distribution
            % in the gpc, for which the default polynomial system is
            % orthogonal) to the actual distribution
            y=(x-dist.mean)*2/(dist.b-dist.a);
        end
        
        function polysys=default_sys_letter(dist, is_normalized)
            % DEFAULT_POLYSYS gives the 'natural' polynomial system
            % belonging to the distribution
            if nargin<1||~is_normalized
                polysys='P';
            else
                polysys='p';
            end
        end
        
        function poly=default_polys(dist, is_normalized)
            if nargin<2;
                is_normalized=false;
            end
            poly=LegendrePolynomials(is_normalized);
        end
    end
end
