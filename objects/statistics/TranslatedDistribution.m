classdef TranslatedDistribution < Distribution
    % TRANSLATEDDISTRIBUTION tranlates a distribution.
    % TDIST=TRANSLATEDDISTRIBUTION(DIST,SHIFT,SCALE,MEAN) translates
    % distribution DIST in regard to parameters SHIFT,SCALE,MEAN
    %
    % Example (<a href="matlab:run_example TranslatedDistribution">run</a>)
    %   dist = SemiCircleDistribution();
    %   tdist = TranslatedDistribution(dist, 2, 0.5);
    %   tdist = TranslatedDistribution(dist, -1, 2, 0);
    %   [mean,variance]=dist.moments()
    %   [mean,variance]=tdist.moments()
    %
    %   x = sort([dist.invcdf(linspace(0,1)), tdist.invcdf(linspace(0,1))]);
    %   plot(x, dist.pdf(x), x, tdist.pdf(x));
    %   legend('orig', 'translated');
    %
    % See also DISTRIBUTION
    
    %   Elmar Zander, Aidin Nojavan, Noemi Friedman
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
        % The parameter DIST of the
        % TRANSLATEDDISTRIBUTION(DIST,shift,scale,CENTER).
        % DIST is the original distribution.
        dist;
        % The parameter SHIFT of the
        % TRANSLATEDDISTRIBUTION(dist,SHIFT,scale,CENTER).
        % SHIFT will shift the distribution to right or left.
        shift;
        % The parameter SCALE of the
        % TRANSLATEDDISTRIBUTION(dist,shift,SCALE,CENTER). Scale the whole
        % distribution by the factor SCALE. Note that scaling is done
        % aroundthe mean of the distribution and thus the mean is not
        % affected by scaling.
        scale;
        % The parameter CENTER of the
        % TRANSLATEDDISTRIBUTION(dist,shift,scale,CENTER).
        % The CENTER refers to mean of the originial distribution.
        center;
    end
    
    methods
        function str=tostring(tdist)
            % Displays the distribution type: 'Translated(dist(param), shift, scale)'
            str=sprintf('Translated(%s, %g, %g, %g)', tdist.dist.tostring(), tdist.shift, tdist.scale, tdist.center);
        end
    end
    
    methods
        function tdist = TranslatedDistribution(dist,shift,scale,center)
            % TRANSLATEDDISTRIBUTION tranlates a distribution.
            % TDIST=TRANSLATEDDISTRIBUTION(DIST,SHIFT,SCALE,MEAN) translates
            % distribution DIST in regard to parameters SHIFT,SCALE,MEAN
            tdist.dist = dist;
            tdist.shift = shift;
            tdist.scale = scale;
            if nargin<4
                tdist.center=tdist.dist.moments();
            else
                tdist.center = center;
            end
        end
        
        function y=translate_points(tdist, x, forward)
            if forward
                y = TranslatedDistribution.translate_points_forward(x, tdist.shift, tdist.scale, tdist.center);
            else
                y = TranslatedDistribution.translate_points_backwards(x, tdist.shift, tdist.scale, tdist.center);
            end
        end
        
        function y=pdf(tdist,x)
            % Y=PDF(TDIST,X) computes the pdf of translated distribution of
            % original distribution, defined as a parameter of TDIST and
            % values X
            x=tdist.translate_points(x, false);
            % computes the translated X values in regard to parameters
            % shift, center and scale
            y=tdist.dist.pdf(x)/tdist.scale;
        end
        
        function y=cdf(tdist,x)
            % Y=CDF(TDIST,X) computes the cdf of translated distribution of
            % original distribution, defined as a parameter of TDIST and
            % values X
            x=tdist.translate_points(x, false);
            % computes the translated X values in regard to parameters
            % shift, center and scale
            y=tdist.dist.cdf(x);
        end
        
        function x=invcdf(tdist,y)
            % Y=INVCDF(TDIST,X) computes the inverse cdf of translated
            % distribution of the original distribution, defined as a
            % parameter of TDIST and values X
            x=tdist.dist.invcdf(y);
            x=tdist.translate_points(x, true);
        end
        
        function xi=sample(tdist,n)
            %   Draw random samples from Translated distribution.
            %   XI=SAMPLE(DIST,N) draws N random samples from the random
            %   distribution DIST. If N is a scalar value XI is a column vector of
            %   random samples of size [N,1]. If N is a vector XI is a matrix (or
            %   tensor) of size [N(1), N(2), ...].
            xi=tdist.dist.sample(n);
            xi=tdist.translate_points(xi, true);
        end
        
        function [mean,var,skew,kurt]=moments(tdist)
            % MOMENTS compute the moments of the translated distribution.
            m = {nan, nan, nan, nan};
            [m{1:nargout}] = tdist.dist.moments();
            m=TranslatedDistribution.translate_moments(m, tdist.shift, tdist.scale, tdist.center);
            [mean,var,skew,kurt]=deal(m{:});
        end
        function dist_germ=get_base_dist(tdist)
            % Get base distribution (corresponding to standard distribution
            % in the gpc, for which the default polynomial system is orthogonal)
            dist_germ=get_base_dist(tdist.dist);
        end
    end
    
    methods (Static)
        function y=translate_points_forward(x, shift, scale, center)
                y=(x-center)*scale+center+shift;
        end
        
        function y=translate_points_backwards(x, shift, scale, center)
                y=(x-shift-center)/scale+center;
        end
        
        function m=translate_moments(m, shift, scale, center)
            % MOMENTS compute the translated moments.
            
            if length(m)>=1
                % Mean needs to be translated like any old point
                m{1}=TranslatedDistribution.translate_points_forward(m{1}, shift, scale, center);
            end
            
            if length(m)>=2
                % Variance is not affected by any shifting or the center
                m{2}=m{2}*scale^2;
            end
            
            % Higher (standardized) moments like skewness or kurtosis are
            % not affected by neither shift nor scale
        end
        
    end
end

