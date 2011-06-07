switch vector_type
    case 'matrix'
        solve_by_gsolve_matrix
    case 'tensor'
        solve_by_gsolve_tensor
    otherwise
        % error unknown vector type
        keyboard
end
