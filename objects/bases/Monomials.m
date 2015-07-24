classdef Monomials < PolynomialSystem
    % MONOMIALS Construct a Monoials.
    % POLY=MONOMIALS(DEG) constructs polynomial system returned in
    % POLY, representing a monomial of order DEG.
    % Example (<a href="matlab:run_example Monomials">run</a>)
    % poly=Monomials(3);
    %
    % See also LEGENDREPOLYNOMIALS POLYNOMIALSYSTEM 
    
    %   Noemi Friedman
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
    end
    
    methods
        function poly=Monomials()
            % HERMITEPOLYNOMIALS Construct a HermitePolynomials.
            % POLY=HERMITEPOLYNOMIALS(DEG) constructs polynomial system
            % returned in POLY, representing an orthogonal Hermite
            % polynomial of order DEG.
        end
    end
    methods(Static)
        function r=recur_coeff(deg)
            % RECUR_COEFF Compute recurrence coefficient of orthogonal polynomials.
            %   R = RECUR_COEFF(POLY) computes the recurrence coefficients for
            %   the system of orthogonal polynomials POLY. The signs are compatible with
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
            r = [zero, one, zero];
        end
        function w_dist=weighting_func()
            w_dist= {'none'};
        end
    end
end
