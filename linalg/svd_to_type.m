function [U,S,V]=svd_to_type( U, S, V, type )

switch type
    case 'empty'
        if isempty(S)
            % do nothing;
        elseif isvector(S)
            U=U*diag(S);
        else
            U=U*S;
        end
        S=[];
    case 'vector'
        if isempty(S)
            S=sqrt(sum(U.^2,1));
            U=U\diag(S);
        elseif isvector(S)
            % do nothing
        else
            S=diag(S);
        end
    case 'matrix'
        if isempty(S)
            S=diag(sqrt(sum(U.^2,1)));
            U=U/S;
        elseif isvector(S)
            S=diag(S);
        else
            % do nothing
        end
end
