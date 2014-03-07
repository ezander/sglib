classdef InverseOperator < Operator
    % INVERSEOPERATOR Implements an inverse operator.
    % INVOP=INVERSEOPERATOR(OP) returns an operator that represents the
    % inverse of OP. This works by delegating calls to apply to solve, and
    % calls to solve are delegated to apply.
    
    properties
        op; % The original operator
    end
    
    methods
        function invop = InverseOperator(op)
            invop.op = op;
        end
        
        function y = apply(invop, x)
            % APPLY Apply inverse operator, i.e. solve with the original one.
            y = invop.op.solve(x);
        end
        
        function s=size_impl(invop)
            % SIZE Size of the inverse operator.
            s=size_impl(invop.op);
            s=s(:,[2, 1]);
        end
        
        function A = asmatrix(invop)
            % ASMATRIX If return the inverse of the orig matrix representation.
            A = inv(invop.op.asmatrix());
        end
        
        function x = solve(invop, y)
            % SOLVE Solve with the inverse operator, i.e. apply the original one.
            x = invop.op.apply(y);
        end
        
        function invop = inv(invop)
            % INV Inverting an inverse operator just returns the original.
            invop = invop.op;
        end
    end
end
