classdef InverseUpdatableOperator < InverseOperator & UpdatableOperator
    methods
        function invop=InverseUpdatableOperator(op)
            invop@InverseOperator(op);
        end
        
        function invop = update(invop, varargin)
            invop.op = invop.op.update(varargin{:});
        end
        
        function invop = inv(invop)
            % INV Inverting an inverse operator just returns the original.
            invop = invop.op;
        end
    end
end
