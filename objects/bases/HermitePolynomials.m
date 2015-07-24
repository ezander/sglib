classdef HermitePolynomials < PolynomialSystem
    % HERMITEPOLYNOMIALS Construct a HermitePolynomials.
    % POLY=HERMITEPOLYNOMIALS(DEG) constructs polynomial system returned in
    % POLY, representing an orthogonal Hermite polynomial of order DEG.
    % Example (<a href="matlab:run_example HermitePolynomials">run</a>)
    % poly=HermitePolynomials(3);
    %
    % See also LEGENDREPOLYNOMIALS POLYNOMIALSYSTEM
    
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
        function poly=HermitePolynomials(is_normalized)
            % HERMITEPOLYNOMIALS Construct a HermitePolynomials.
            % POLY=HERMITEPOLYNOMIALS(DEG) constructs polynomial system
            % returned in POLY, representing an orthogonal Hermite
            % polynomial of order DEG.
            if nargin<2
                is_normalized=false;
            end
            poly.is_normalized=is_normalized;
        end
        function r=recur_coeff(poly, deg)
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
            r = [zero, one, n];
            if poly.is_normalized% lower case signifies normalised polynomials
                z = [0, sqrt(factorial(0:deg))]';
                % row n: p_n+1  = (a_n + x b_n) p_n + c_n p_n-1
                %   =>   z_n+1 q_n+1  = (a_n + x b_n) z_n q_n + c_n z_n-1 p_n-1
                %   =>   q_n+1  = (a_n + x b_n) z_n/z_n+1 q_n + c_n z_n-1/z_n+1 p_n-1
                r = [r(:,1) .* z(n+2) ./ z(n+3), ...
                    r(:,2) .* z(n+2) ./ z(n+3), ...
                    r(:,3) .* z(n+1) ./ z(n+3)];
            end
        end
        function nrm2 =sqnorm(poly, n)
            if nargin<2
                n=0:deg;
            end
            if poly.is_normalized
                nrm2=ones(size(n));
            else
                nrm2 = factorial(n);
            end
        end
    end
    methods(Static)
        function w_dist=weighting_func()
            %w_dist=NormalDistribution(0,1);
            w_dist=gendist_create('normal', {0,1});
        end
    end
end
