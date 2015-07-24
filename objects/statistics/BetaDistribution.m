classdef BetaDistribution < Distribution
    % BETADISTRIBUTION Construct a BetaDistribution.
    %   DIST=BETADISTRIBUTION(A,B) constructs a distribution returned in
    %   DIST representing a beta distribution with parameters A and B.
    %
    % Example (<a href="matlab:run_example BetaDistribution">run</a>)
    %   dist = BetaDistribution(2,3);
    %   [mean,var,skew,kurt]=dist.moments()
    %
    % See also DISTRIBUTION NORMALDISTRIBUTION BETA_PDF
    
    %   Aidin Nojavan (extended by Noemi Friedman)
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
        % The parameter A of the Beta(A,b) distribution. A is a positive
        % shape parameter, that appears as exponent of the random
        % variable and controls the shape of the distribution
        a
        % The parameter B of the Beta(a,B) distribution.  B is a positive
        % shape parameter, that appears as exponent of the random
        % variable and controls the shape of the distribution
        b
        sys
        
    end
    methods
        function dist=BetaDistribution(a,b)
            % BETADISTRIBUTION Construct a BetaDistribution.
            % DIST=BETADISTRIBUTION(A,B) constructs a distribution returned
            % in DIST representing a beta distribution with parameters A
            % and B.
            dist.a=a;
            dist.b=b;
            end
        function y=pdf(dist,x)
            % PDF computes the probability distribution function of the
            % beta distribution.
            y=beta_pdf( x, dist.a, dist.b );
        end
        function y=cdf(dist,x)
            % CDF computes the cumulative distribution function of the beta
            % distribution.
            y=beta_cdf( x, dist.a, dist.b );
        end
        function x=invcdf(dist,y)
            % INVCDF computes the inverse CDF (or quantile) function of the
            % beta distribution.
            x=beta_invcdf( y, dist.a, dist.b );
        end
        function [mean,var,skew,kurt]=moments(dist)
            % MOMENTS computes the moments of the beta distribution.
            m = {nan, nan, nan, nan};
            [m{1:nargout}] = beta_moments( dist.a, dist.b );
            [mean,var,skew,kurt]=deal(m{:});
        end
        function xi=sample(dist,n)
            %   Draw random samples from Beta distribution.
            %   XI=SAMPLE(DIST,N) draws N random samples from the random
            %   distribution DIST. If N is a scalar value XI is a column vector of
            %   random samples of size [N,1]. If N is a vector XI is a matrix (or
            %   tensor) of size [N(1), N(2), ...].
            if isscalar(n)
                yi = rand(n,1);
            else
                yi = rand(n);
            end
                xi = dist.invcdf(yi);
        end
        function polysys=default_sys_letter(dist, is_normalized, varargin)
            % DEFAULT_POLYSYS gives the 'SYS' letter belonging to the 'natural' polynomial system
            % belonging to the distribution
            options = varargin2options(varargin);
            [generate_sys, options] = get_option(options, 'generate_sys', false);
            check_unsupported_options(options, mfilename);
            
            if dist.a==3/2 && dist.b==3/2 %for SemiCircleDistribution
                vsys{1}='u';
                vsys{2}='U';
            elseif dist.a==1/2 && dist.b==1/2 %for ArcSinDistribution
                vsys{1}='t';
                vsys{2}='T';
            elseif generate_sys
                vsys{2}=gpc_register_polysys('',dist);
                vsys{1}=lower(vsys{2});
            else
                vsys{2}='';
                vsys{1}='';
             end
            if is_normalized
                polysys=vsys{1};
            else
                polysys=vsys{2};
            end
        end
        
        function polys=default_polys(dist, is_normalized)
            % DEFAULT_POLYSYS gives the 'natural' polynomial system
            % belonging to the distribution
             if nargin<3;
                is_normalized=false;
                if nargin<2
                 n=0;
                end
             end
            if dist.a==3/2 && dist.b==3/2 %for SemiCircleDistribution
                polys=ChebyshevUPolynomials(is_normalized);
            elseif dist.a==1/2 && dist.b==1/2 %for ArcSinDistribution
                polys=ChebyshevTPolynomials(is_normalized);
            else
                polys=JacobiPolynomials(dist.a-1, dist.b-1, is_normalized);
            end
        end
        function str=tostring(dist)
            % Displays the distribution type: 'Beta(a, b)'
            str=sprintf('Beta(%.3f,  %.3f)', dist.a, dist.b);
        end
        
    end
end