classdef PolynomialSystem < FunctionSystem
    % POLYNOMIALSYSTEM abstract base class for polynomial basis functions
    %
    % See also HERMITEPOLYNOMIALS LEGENDREPOLYNOMIALS
    
    
    %   Aidin Nojavan
    %   Copyright 2014, Inst. of Scientific Computing, TU Braunschweig
    %
    %   This program is free software: you can redistribute it and/or modify it
    %   under the terms of the GNU General Public License as published by the
    %   Free Software Foundation, either version 3 of the License, or (at your
    %   option) any later version.
    %   See the GNU General Public License for more details. You should have
    %   received a copy of the GNU General Public License along with this
    %   program.  If not, see <http://www.gnu.org/licenses/>.
    methods (Abstract)
        r=recur_coeff(sys) % RECUR_COEFF compute recursion coefficients of 
                           % the basis function
    end
    methods
        function y_alpha_j=evaluate(sys,xi)
            % EVALUATE Evaluates the basis functions at given points.
            %   Y_ALPHA_J = EVALUATE(SYS, XI) evaluates the basis function 
            %   specified by SYS at the points specified by XI. If there 
            %   are M basis functions and XI is 1 x N matrix, where N is
            %   the number of evaulation points, then the returned matrix Y 
            %   is of size N x M such that Y(j,I) is the I-th basis function
            %   evaluated at point XI(J).
            k = size(xi, 2);
            n = (0:sys.deg-1)';
            p = zeros(k,sys.deg);
            p(:,1) = 0;
            p(:,2) = 1;
            r = recur_coeff(sys);
            for d=1:sys.deg-1
                p(:,d+2) = (r(d,1) + xi' * r(d, 2)) .* p(:,d+1) - r(d,3) * p(:,d);
            end
            
            y_alpha_j = p(:,2:end);
        end
        
    end
end

