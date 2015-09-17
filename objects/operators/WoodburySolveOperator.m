classdef WoodburySolveOperator < UpdatableOperator
    properties
        A, Ainv
        U, V
    end
    
    methods
        function wsop=WoodburySolveOperator(A, Ainv, U, V)
            if nargin<2
                Ainv = [];
            end
            assert(~(isempty(A) && isempty(Ainv)), 'A and Ainv may not both be empty');
            
            wsop.A = MatrixOperator.wrap_if_necessary(A);
            wsop.Ainv = MatrixOperator.wrap_if_necessary(Ainv);
            if isempty(wsop.A)
                wsop.A = inv(wsop.Ainv);
            end
            if isempty(wsop.Ainv)
                wsop.Ainv = inv(wsop.A);
            end
            
            if nargin<3
                n = size(wsop.A,1);
                wsop.U = zeros(n,0);
                wsop.V = zeros(n,0);
            else
                wsop.U = U;
                wsop.V = V;
            end
        end
        
        function y=apply(wsop, x)
            y1 = apply(wsop.A, x);
            y2 = wsop.U*(wsop.V'*x);
            y = y1 + y2;
        end

        function x=solve(wsop, y)
            x=wsop.woodbury_solve(wsop.Ainv, wsop.U, wsop.V, y);
        end

        function s=size_impl(wsop)
            s = size(wsop.Ainv);
        end
        
        function A=asmatrix(wsop)
            A=asmatrix(inv(wsop.Ainv)) + wsop.U*wsop.V';
        end
        
        function wsop=update(wsop, u, v)
            wsop.U = [wsop.U, u];
            wsop.V = [wsop.V, v];
        end
    end
    
    methods(Static=true)
        function Y=woodbury_solve(Ainv, U, V, X)
            k = size(U,2);
            M = eye(k) + V' * apply(Ainv, U);
            Z1 = apply(Ainv, X);
            Z2 = apply(Ainv, U * (M \ (V' * Z1)));
            Y = Z1 - Z2;
        end
    end
end
