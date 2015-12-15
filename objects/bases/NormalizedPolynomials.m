classdef NormalizedPolynomials < PolynomialSystem
    % NORMALIZEDPOLYNOMIALS Wrapper class for normalizing polynomial systems. 
    %
    % See also POLYNOMIALSYSTEM
    
    %   Elmar Zander
    %   Copyright 2014, Inst. of Scientific Computing, TU Braunschweig
    %
    %   This program is free software: you can redistribute it and/or modify it
    %   under the terms of the GNU General Public License as published by the
    %   Free Software Foundation, either version 3 of the License, or (at your
    %   option) any later version.
    %   See the GNU General Public License for more details. You should have
    %   received a copy of the GNU General Public License along with this
    %   program.  If not, see <http://www.gnu.org/licenses/>.
    
    properties (SetAccess=protected)
        base_polysys
    end
    
    methods
        function polysys=NormalizedPolynomials(base_polysys)
            polysys.base_polysys = base_polysys;
        end

        function r=recur_coeff(polysys, deg)
            % RECUR_COEFF Compute recurrence coefficient of orthogonal polynomials.
            %   R = RECUR_COEFF(POLYSYS, DEG) computes the recurrence coefficients for
            %   the system of orthogonal polynomials POLYSYS. The coefficients
            %   of the base polynomial are converted such that the
            %   resulting polynomials are normalised.
            %
            % See also POLYNOMIALSYSTEM.RECUR_COEFF
            r = polysys.base_polysys.recur_coeff(deg);
            n = 0:deg-1;
            z = [0, sqrt(polysys.base_polysys.sqnorm(0:deg))]';
            % row n: p_n+1  = (a_n + x b_n) p_n + c_n p_n-1
            %   =>   z_n+1 q_n+1  = (a_n + x b_n) z_n q_n + c_n z_n-1 p_n-1
            %   =>   q_n+1  = (a_n + x b_n) z_n/z_n+1 q_n + c_n z_n-1/z_n+1 p_n-1
            r = [r(:,1) .* z(n+2) ./ z(n+3), ...
                r(:,2) .* z(n+2) ./ z(n+3), ...
                r(:,3) .* z(n+1) ./ z(n+3)];
        end
        
        function nrm2=sqnorm(~, n)
            % SQNORM Compute square norm of orthogonal polynomials.
            %   This pretty trivial in case of normalised polynomials.
            % See also POLYNOMIALSYSTEM.SQNORM
            nrm2=ones(size(n));
        end
        
        function polysys=normalized(polysys)
            % NORMALIZED Return a normalized version of these polynomials
            %   Needs to do nothing in this case.
            % See also POLYNOMIALSYSTEM.NORMALIZED
        end
        
        function dist=weighting_dist(polysys)
            % WEIGHTING_DIST Return a distribution wrt to which the polynomials are orthogonal.
            %   DIST=WEIGHTING_DIST(POLYSYS) returns weighting dist of the
            %   base polynomials.
            %   
            % See also DISTRIBUTION POLYNOMIALSYSTEM.WEIGHTING_DIST
            dist = polysys.base_polysys.weighting_dist();
        end
    end
end

