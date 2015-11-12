classdef SemiCircleDistribution < BetaDistribution
    % SEMICIRCLEDISTRIBUTION Construct a BetaDistribution.
    %   DIST=SEMICIRCLEDISTRIBUTION() constructs a beta distribution returned in
    %   DIST representing a beta distribution with parameters A=3/2 and
    %   B=3/2shifted to have bounds [a,b]
    %
    % Example (<a href="matlab:run_example SemiCircleDistribution">run</a>)
    %   dist = SemiCircleDistribution();
    %   [mean,var,skew,kurt]=dist.moments()
    %
    % See also DISTRIBUTION BETADISTRIBUTION BETA_PDF
    
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
        function dist = SemiCircleDistribution()
            dist@BetaDistribution(3/2, 3/2);
            %dist= fix_bounds(dist, a, b);
        end
        
        function str=tostring(dist) %#ok<MANU>
            % TOSTRING Displays the distribution type.
            str=sprintf('SemiCircle()');
        end

        function polysys=default_sys_letter(dist, is_normalized) %#ok<INUSL>
            % DEFAULT_SYS_LETTER gives the 'SYS' letter belonging to the
            % 'natural' polynomial system belonging to the distribution.
            if is_normalized
                polysys = 'u';
            else
                polysys = 'U';
            end
        end

        function polys=default_polys(dist, is_normalized)
            % DEFAULT_POLYS gives the 'natural' polynomial system
            % belonging to the distribution
            if nargin<2
                is_normalized=false;
            end
            polys=ChebyshevUPolynomials(is_normalized);
        end
        
    end
end
