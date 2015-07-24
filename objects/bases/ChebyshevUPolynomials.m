classdef ChebyshevUPolynomials < PolynomialSystem
    % CHEBYSHEVUPOLYNOMIALS Constructs a ChebyshevUPolynomials.
    % SYS=CHEBYSHEVUPOLYNOMIALS(DEG) constructs polynomial system returned
    % in SYS, representing a 2nd kind Chebyshev polynomial of order DEG.
    % Example (<a href="matlab:run_example ChebyshevUPolynomials">run</a>)
    % sys=ChebyshevUPolynomials(4);
    %
    % See also LEGENDREPOLYNOMIALS LAGUERREPOLYNOMIALS
    
    %   Aidin Nojavan further extended by Noemi Friedman
    %   Copyright 2014, Inst. of Scientific Computing, TU Braunschweig
    %
    %   This program is free software: you can redistribute it and/or modify it
    %   under the terms of the GNU General Public License as published by the
    %   Free Software Foundation, either version 3 of the License, or (at your
    %   option) any later version.
    %   See the GNU General Public License for more details. You should have
    %   received a copy of the GNU General Public License along with this
    %   program.  If not, see <http://www.gnu.org/licenses/>.
    properties
        % IS_NORMALIZED choses whether the polynomial should
        % be only orthogonal (IS_NORMALIZED=false) , or orthonormal (IS_NORMALIZED=true)
        % The default value is 'FALSE'
        is_normalized
    end
    
    methods
        function poly=ChebyshevUPolynomials(is_normalized)
            % CHEBYSHEVUPOLYNOMIALS Construct a ChebyshevUPolynomials.
            % SYS=CHEBYSHEVUPOLYNOMIALS(DEG) constructs polynomial system
            % returned in SYS, representing a 2nd kind Chebyshev
            % polynomial of order DEG.
            if nargin<1
                is_normalized=false;
            end
            poly.is_normalized=is_normalized;
        end
        function r=recur_coeff(poly, deg)
            % RECUR_COEFF Compute recurrence coefficient of orthogonal polynomials.
            %   R = RECUR_COEFF(SYS) computes the recurrence coefficients for
            %   the system of orthogonal polynomials SYS. The signs are compatible with
            %   the ones given in Abramowith & Stegun 22.7:
            %
            %       p_n+1  = (a_n + x b_n) p_n - c_n p_n-1
            %
            %   Since matlab indices start at one, we have here the mapping
            %
            %       r(n,:) = (a_n-1, b_n-1, c_n-1)
            %
            %   Furthermore the coefficients start here for p_1, so that only p_-1=0
            %   and p_0=1 need to be fixed (otherwise p_1, would need to be another
            %   parameter, since it's not always equal to x). Therefore there needs to
            %   be a little extra treatment for the coefficient of the Chebyshev
            %   polynomials of the first kind, esp. T_1).
            % References:
            %   [1] Abramowitz & Stegun: Handbook of Mathematical Functions
            %   [2] http://dlmf.nist.gov/18.9
            n = (0:deg-1)';
            one = ones(size(n));
            zero = zeros(size(n));
            r = [zero, 2*one, one];
        end
        
    end
     methods(Static)
        function w_dist=weighting_func()
            %w_dist=SemiCircleDistribution(-1,1);
            w_dist= gendist_create('semicircle');
        end
        function nrm2 =sqnorm(n)
            nrm2 = ones(size(n));
        end
    end
end
