classdef JacobiPolynomials < PolynomialSystem
    %JACOBIITEPOLYNOMIALS Construct the JacobiPolynomials.
    %
    % Example (<a href="matlab:run_example JacobiPolynomials">run</a>)
    %   poly=JacobiPolynomials(0.4, 2);
    %   x=linspace(-1,1);
    %   y=poly.evaluate(4, x);
    %   plot(x,y);
    %
    % See also LEGENDREPOLYNOMIALS POLYNOMIALSYSTEM
    
    %   Noemi Friedman, Elmar Zander
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
        % ALPHA First parameter of the Jacobi polynomials
        alpha
        % BETA Second parameter of the Jacobi polynomials
        beta
    end
    
    methods
        function poly=JacobiPolynomials(alpha, beta)
            % JACOBIPOLYNOMIALS Construct the JacobiPolynomials.
            %   POLY=JACOBIPOLYNOMIALS(ALPHA, BETA) constructs a polynomial
            %   system returned in POLY, representing the orthogonal Jacobi
            %   polynomials with parameters ALPHA and BETA.
            poly.alpha=alpha;
            poly.beta=beta;
        end
        
        function r=recur_coeff(poly, deg)
            % RECUR_COEFF Compute recurrence coefficient of the Jacobi polynomials.
            %
            % See also POLYNOMIALSYSTEM.RECUR_COEFF
            %
            % References:
            %   [1] http://dlmf.nist.gov/18.9.i
            n = (0:deg-1)';
            a=poly.alpha;
            b=poly.beta;
            
            b_n=(2*n+a+b+1).*(2*n+a+b+2)./...
                ( 2*(n+1).*(n+a+b+1) );
            a_n=(a^2-b^2).*(2*n+a+b+1)./...
                ( 2*(n+1).*(n+a+b+1).*(2*n+a+b) );
            c_n=(n+a).*(n+b).*(2*n+a+b+2)./...
                ( (n+1).*(n+a+b+1).*(2*n+a+b) );
            
            if a+b==0 || a+b==-1
                b_n(1)=0.5*(a+b)+1;
                a_n(1)=0.5*(a-b);
                c_n(1)=0;
            end
            r = [a_n, b_n, c_n];
        end
        
        function nrm2=sqnorm(poly, n)
            % SQNORM Compute the square norm of the Jacobi polynomials.
            %    Norm wrt the weighting function:
            %
            %         x^alpha  (1-x)^beta
            %     w= --------------------
            %          Beta(alpha,beta)
            %
            % References:
            %   [1] http://dlmf.nist.gov/18.3.T1
            %
            % See also POLYNOMIALSYSTEM.SQNORM
            nrm2 = sqnorm@PolynomialSystem(poly, n);
            % The following needs to be checked:
            %             a=poly.alpha;
            %             b=poly.beta;
            %
            %             nrm2=2^(a+b+1)*gamma(n+a+1).*gamma(n+b+1)./...
            %                 (  (2*n+a+b+1) .*gamma(n+a+b+1).*factorial(n) );
            %             %nrm2(1)=2^(a+b+1)*gamma(a+1).*gamma(b+1)./...
            %             %    ( gamma(a+b+1));
            %             %Normalize to the form of the beta distribution
            %             g=1%/(2*beta(b+1, a+1)*(2^a)*(2^b));
            %             nrm2=g*nrm2;
        end
        
        %         function w_dist=weighting_func(poly)
        %             %w_dist=fix_bounds(BetaDistribution(poly.alpha+1,poly.beta+1),-1,1);
        %             w_dist=gendist_fix_bounds(gendist_create('beta', {poly.beta+1,poly.alpha+1}), -1,1);
        %         end
    end
end
