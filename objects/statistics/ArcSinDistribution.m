classdef ArcSinDistribution < BetaDistribution
    % ARCSINDISTRIBUTION Construct a BetaDistribution.
    %   DIST=ARCSINDISTRIBUTION() constructs a beta distribution returned in
    %   DIST representing a beta distribution with parameters A=3/2 and
    %   B=3/2 shifted to have bounds [a,b]
    %
    % Example (<a href="matlab:run_example ArcSinDistribution">run</a>)
    %   dist = ArcSinDistribution();
    %   [mean,var,skew,kurt]=dist.moments()
    %
    % See also DISTRIBUTION BETADISTRIBUTION NORMALDISTRIBUTION BETA_PDF
    
    %   Noemi Friedman
    %   Copyright 2015, Inst. of Scientific Computing, TU Braunschweig
    %
    %   This program is free software: you can redistribute it and/or
    %   modify it under the terms of the GNU General Public License as
    %   published by the Free Software Foundation, either version 3 of the
    %   License, or (at your option) any later version.
    %   See the GNU General Public License for more details. You should
    %   have received a copy of the GNU General Public License along with
    %   this program.  If not, see <http://www.gnu.org/licenses/>.
    
    methods
        function dist = ArcSinDistribution()
            dist@BetaDistribution(1/2, 1/2);
        end
        
        function str=tostring(dist) %#ok<MANU>
            % TOSTRING Displays the distribution type.
            str=sprintf('ArcSin()');
        end
    end
    
    methods
        function polysys=default_sys_letter(dist, is_normalized) %#ok<INUSL>
            % DEFAULT_SYS_LETTER gives the 'SYS' letter belonging to the
            % 'natural' polynomial system belonging to the distribution.
            if nargin>=2 && is_normalized
                polysys = 't';
            else
                polysys = 'T';
            end
        end
        
        function polys=default_polys(dist, is_normalized)
            % DEFAULT_POLYS gives the 'natural' polynomial system
            % belonging to the distribution
            if nargin<2;
                is_normalized=false;
            end
            polys=ChebyshevTPolynomials(is_normalized);
        end
    end
end