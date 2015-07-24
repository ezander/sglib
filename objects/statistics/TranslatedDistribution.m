classdef TranslatedDistribution < Distribution
    % TRANSLATEDDISTRIBUTION tranlates a distribution.
    % TDIST=TRANSLATEDDISTRIBUTION(DIST,SHIFT,SCALE,MEAN) translates
    % distribution DIST in regard to parameters SHIFT,SCALE,MEAN
    %
    % Example (<a href="matlab:run_example TranslatedDistribution">run</a>)
    %
    % See also DISTRIBUTION
    
    %   Aidin Nojavan (slightly modified by Noemi Friedman)
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
        
        function y=pdf(tdist,x)
            % Y=PDF(TDIST,X) computes the pdf of translated distribution of
            % original distribution, defined as a parameter of TDIST and
            % values X
            x=(x-tdist.shift-tdist.center)/tdist.scale+tdist.center;
            % computes the translated X values in regard to parameters
            % shift, center and scale
            y=tdist.dist.pdf(x)/tdist.scale;
        end
        
        function y=cdf(tdist,x)
            % Y=CDF(TDIST,X) computes the cdf of translated distribution of
            % original distribution, defined as a parameter of TDIST and
            % values X
            x=(x-tdist.shift-tdist.center)/tdist.scale+tdist.center;
            % computes the translated X values in regard to parameters
            % shift, center and scale
            y=tdist.dist.cdf(x);
        end
        function x=invcdf(tdist,y)
            % Y=INVCDF(TDIST,X) computes the inverse cdf of translated
            % distribution of the original distribution, defined as a
            % parameter of TDIST and values X
            x=tdist.dist.invcdf(y);
            x=(x-tdist.center)*tdist.scale+tdist.center+tdist.shift;
        end
        function xi=sample(tdist,n)
            %   Draw random samples from Translated distribution.
            %   XI=SAMPLE(DIST,N) draws N random samples from the random
            %   distribution DIST. If N is a scalar value XI is a column vector of
            %   random samples of size [N,1]. If N is a vector XI is a matrix (or
            %   tensor) of size [N(1), N(2), ...].
            if isscalar(n)
                yi = rand(n,1);
            else
                yi = rand(n);
            end
            xi = tdist.invcdf(yi);
        end
        function [mean,var,skew,kurt]=moments(tdist)
            % MOMENTS compute the moments of the translated distribution.
            % TODO: check this functions if mean of underlying distribution
            % is not the same as the center. I guess we will have to add
            % something like (tdist.center + tdist.dist.mean())^2 to the
            % variance.
            n=max(nargout,1);
            m=cell(1,n);
            [m{:}]=tdist.dist.moments();
            mean=m{1}+tdist.shift;
            if nargout>=2
                var=m{2}*tdist.scale^2;
            end
            if nargout>=3
                skew=m{3};
            end
            if nargout>=4
                kurt=m{4};
            end
        end
        function polys=default_polys(tdist)
            % Returns name of polynomials, which are orthogonal  wrt. the
            % distribution standardized
            polys=tdist.dist.default_polys();
        end
        function sys=default_sys_letter(tdist, is_normalized)
            % DEFAULT_SYS_LETTER gives the letter corresponding to the 'natural' polynomial system
            sys=tdist.dist.default_sys_letter(is_normalized);
        end
        function str=tostring(tdist)
            % Displays the distribution type: 'Translated(dist(param), shift, scale)'
            str=sprintf('Translated(%s,  %.3f,  %.3f)', tdist.dist.tostring(), tdist.shift, tdist.scale);
        end
    end
end

