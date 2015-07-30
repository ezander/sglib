classdef JacobiPolynomials < PolynomialSystem
    %JACOBIITEPOLYNOMIALS Construct JacobiPolynomials.
    % POLY=JACOBIPOLYNOMIALS(DEG) constructs polynomial system returned in
    % POLY, representing an orthogonal JACOBI polynomial of order DEG.
    % Example (<a href="matlab:run_example JacobiPolynomials">run</a>)
    % sys=JacobiPolynomials(3);
    %
    % See also LEGENDREPOLYNOMIALS POLYNOMIALSYSTEM 
    
    %   Noemi Friedman & Elmar Zander
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
        % The two parameters for Jacobi polynomials
        alpha
        beta
         % IS_NORMALIZED choses whether the polynomial should
        % be only orthogonal (IS_NORMALIZED=false) , or orthonormal (IS_NORMALIZED=true)
        % The default value is 'FALSE'
        is_normalized
    end
    
    methods
        function poly=JacobiPolynomials(alpha, beta, is_normalized)
            % HERMITEPOLYNOMIALS Construct a HermitePolynomials.
            % POLY=HERMITEPOLYNOMIALS(DEG) constructs polynomial system
            % returned in POLY, representing an orthogonal Hermite
            % polynomial of order DEG.
            if nargin<3
                is_normalized=false;
            end
            poly.alpha=alpha;
            poly.beta=beta;
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
            a=poly.alpha;
            b=poly.beta;
            %one = ones(size(n));
            %zero = zeros(size(n));
            b_n=(2*n+a+b+1).*(2*n+a+b+2)./...
                ( 2*(n+1).*(n+a+b+1) );
            a_n=(a^2-b^2).*(2*n+a+b+1)./...
                ( 2*(n+1).*(n+a+b+1).*(2*n+a+b) );
            c_n=(n+a).*(n+b).*(2*n+a+b+2)./...
                ( (n+1).*(n+a+b+1).*(2*n+a+b) );
            if a+b==0 ||a+b==-1
                b_n(1)=0.5*(a+b)+1;
                a_n(1)=0.5*(a-b);
                c_n(1)=0;
            end
            r = [a_n, b_n, c_n];
            
            if poly.is_normalized% lower case signifies normalised polynomials
                n=0:deg;
                g=1/(2*beta(b+1, a+1)*(2^a)*(2^b));
                 nrm2=g*2^(a+b+1)*gamma(n+a+1).*gamma(n+b+1)./...
                (  (2*n+a+b+1) .*gamma(n+a+b+1).*factorial(n) );
                nrm2(1)=g*2^(a+b+1)*gamma(a+1).*gamma(b+1)./...
                ( gamma(a+b+1));
                z = [0, sqrt(nrm2)]';
                % row n: p_n+1  = (a_n + x b_n) p_n + c_n p_n-1
                %   =>   z_n+1 q_n+1  = (a_n + x b_n) z_n q_n + c_n z_n-1 p_n-1
                %   =>   q_n+1  = (a_n + x b_n) z_n/z_n+1 q_n + c_n z_n-1/z_n+1 p_n-1
                n = (0:deg-1)';
                r = [r(:,1) .* z(n+2) ./ z(n+3), ...
                    r(:,2) .* z(n+2) ./ z(n+3), ...
                    r(:,3) .* z(n+1) ./ z(n+3)];
            end
        end
        function nrm2=sqnorm(poly, n)
            %Norm wrt the weighting function:
            %
            %          x^alpha  (1-x)^beta
            % w= --------------------
            %              Beta(alpha,beta)
            %
            a=poly.alpha;
            b=poly.beta;
            
            nrm2=2^(a+b+1)*gamma(n+a+1).*gamma(n+b+1)./...
                (  (2*n+a+b+1) .*gamma(n+a+b+1).*factorial(n) );
            %nrm2(1)=2^(a+b+1)*gamma(a+1).*gamma(b+1)./...
            %    ( gamma(a+b+1));
            %Normalize to the form of the beta distribution
            g=1/(2*beta(b+1, a+1)*(2^a)*(2^b));
            nrm2=g*nrm2;
        end
        function w_dist=weighting_func(poly)
            %w_dist=fix_bounds(BetaDistribution(poly.alpha+1,poly.beta+1),-1,1);
            w_dist=gendist_fix_bounds(gendist_create('beta', {poly.beta+1,poly.alpha+1}), -1,1);
        end
    end
end
