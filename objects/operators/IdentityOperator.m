classdef IdentityOperator < Operator
    % IDENTITYOPERATOR Efficient implementation of the identity operator.
    properties
        n
    end
    methods
        function idop=IdentityOperator(n)
            idop.n = n(:);
        end
        
        function x=apply(idop, x) %#ok<INUSL>
        end
        
        function x=solve(idop, x) %#ok<INUSL>
        end
        
        function s=size_impl(idop)
            s = [idop.n, idop.n];
        end
        
        function A=asmatrix(idop)
            A = speye(prod(idop.n));
        end
        
        function op = compose(idop, other_op)
            % COMPOSE Create the composition of two operators.
            op = other_op;
        end
        
        function op = inv(idop)
            % INV Invert the operator.
            op = idop;
        end
    end
    methods (Static)
        function idop=from_vector(x)
            idop = IdentityOperator(tensor_size(x,true));
        end
    end
end
