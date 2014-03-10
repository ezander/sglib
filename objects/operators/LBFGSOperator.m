classdef LBFGSOperator < UpdatableOperator
    properties
        H0
        L
        S
        Y
    end
    
    methods
        function lop = LBFGSOperator(H0, L)
            if nargin<1
                L=10;
            end
            lop.H0 = H0;
            lop.L = L;
            lop.S = {};
            lop.Y = {};
        end
        
        function y=apply(lop, x)
            error('Not yet implemented');
        end

        function A=asmatrix(lop)
            error('Not yet implemented');
        end

        function x=solve(lop, y)
            x = lbfgs_solve(lop.H0, lop.Y, lop.S, y);
        end
        
        function s=size_impl(lop)
            s=size(lop.H0);
        end
        
        function lop = update(lop, y, s)
            if lop.L==0
                return
            end
            
            k = length(lop.S);
            if k>=lop.L
                k0 = 2;
            else
                k0 = 1;
            end
            lop.Y = {lop.Y{k0:k}, y};
            lop.S = {lop.S{k0:k}, s};
        end
            
    end
        
end