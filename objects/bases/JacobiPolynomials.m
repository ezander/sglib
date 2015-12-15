classdef JacobiPolynomials < PolynomialSystem
    %JACOBIITEPOLYNOMIALS Construct the JacobiPolynomials.
    %
    % Example 1 (<a href="matlab:run_example JacobiPolynomials 1">run</a>)
    %   polysys=JacobiPolynomials(1.5, -0.5);
    %   x=linspace(-1,1);
    %   y=polysys.evaluate(5, x);
    %   plot(x,y);
    %   grid on; ylim([-1.5, 5]);
    %
    % Example 2 (<a href="matlab:run_example JacobiPolynomials 2">run</a>)
    %   polysys=JacobiPolynomials(1.25, 0.75);
    %   x=linspace(-1,1);
    %   y=polysys.evaluate(8, x);
    %   plot(x,y(:,8:9));
    %   grid on; ylim([-1.5, 1.5]);
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
    
    properties (SetAccess=protected)
        % ALPHA First parameter of the Jacobi polynomials
        alpha
        
        % BETA Second parameter of the Jacobi polynomials
        beta
    end
    
    methods
        function polysys=JacobiPolynomials(alpha, beta)
            % JACOBIPOLYNOMIALS Construct the JacobiPolynomials.
            %   POLYSYS=JACOBIPOLYNOMIALS(ALPHA, BETA) constructs a polynomial
            %   system returned in POLYSYS, representing the orthogonal Jacobi
            %   polynomials with parameters ALPHA and BETA.
            polysys.alpha=alpha;
            polysys.beta=beta;
        end
        
        function r=recur_coeff(polysys, deg)
            % RECUR_COEFF Compute recurrence coefficient of the Jacobi polynomials.
            %
            % See also POLYNOMIALSYSTEM.RECUR_COEFF
            %
            % References:
            %   [1] http://dlmf.nist.gov/18.9.i
            n = (0:deg-1)';
            a=polysys.alpha;
            b=polysys.beta;
            
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
        
        function nrm2=sqnorm(polysys, n)
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
            nrm2 = sqnorm@PolynomialSystem(polysys, n);
            % The following needs to be checked:
            %             a=polysys.alpha;
            %             b=polysys.beta;
            %
            %             nrm2=2^(a+b+1)*gamma(n+a+1).*gamma(n+b+1)./...
            %                 (  (2*n+a+b+1) .*gamma(n+a+b+1).*factorial(n) );
            %             %nrm2(1)=2^(a+b+1)*gamma(a+1).*gamma(b+1)./...
            %             %    ( gamma(a+b+1));
            %             %Normalize to the form of the beta distribution
            %             g=1%/(2*beta(b+1, a+1)*(2^a)*(2^b));
            %             nrm2=g*nrm2;
        end
        
        function dist=weighting_dist(polysys)
            % WEIGHTING_DIST Return a distribution wrt to which the Hermite polynomials are orthogonal.
            %   DIST=WEIGHTING_DIST(POLYSYS) returns the a standard normal
            %   distribution, i.e. NormalDistribution(0,1).
            %
            % See also DISTRIBUTION POLYNOMIALSYSTEM.WEIGHTING_DIST
            dist = BetaDistribution(polysys.beta+1, polysys.alpha+1);
        end
    end
end
