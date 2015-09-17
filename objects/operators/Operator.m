classdef Operator
    % OPERATOR Base class for operators.
    methods (Abstract)
        y=apply(op, x);
        s=size_impl(op);
        A=asmatrix(op);
    end
    methods 
        % Methods, that are not abstract, because not all derived classes
        % can implement them, but should be overridden, if possible.
        function x = solve(op, y)  %#ok<STOUT,INUSD>
            error('sglib:not_implemented', 'Solve not implemented for class %s', class(op));
        end
        
        function s=size(op, dim, contract)
            % SIZE Return the size of the operator.
            s = size_impl(op);
            if nargin>1 && ~isempty(dim)
                s = s(:,dim);
            end
            if nargin<=2 || isempty(contract) || contract
                s = prod(s, 1);
            end
        end
        
        
        % Methods, that can be overridden, if necessary or the derived class
        % has a faster implementations
        function op = compose(op, other_op)
            % COMPOSE Create the composition of two operators.
            op = ComposedOperator(other_op, op);
        end
        
        function op = inv(op)
            % INV Invert the operator.
            op = InverseOperator(op);
        end
        
        function r=residual(op, x, b)
            % RESIDUAL Compute the residual b - A*x.
            y=op.apply(x);
            r=tensor_add(b, y, -1);
        end
        
        function varargout=eig(op)
            [varargout{1:nargout}] = eig(op.asmatrix());
        end
        
        % Overrriden operators
        function op_or_vec = mtimes(op, op_or_vec)
            % MTIMES Override the * operator.
            if isa(op_or_vec, 'Operator')
                op_or_vec = compose(op, op_or_vec);
            else
                op_or_vec = apply(op, op_or_vec);
            end
        end
        
        function op_or_vec = mldivide(op, op_or_vec)
            % MLDIVIDE Override the \ operator.
            if isa(op_or_vec, 'Operator')
                error('please use proper parenthesis');
            else
                op_or_vec = solve(op, op_or_vec);
            end
        end
    end
end
