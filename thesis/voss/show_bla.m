% determine: how is contractivity determined by update ratio

if true
    clear
    model_1d_small
    define_geometry
    discretize_model
    setup_equation
end

%solve_by_standard_pcg

solve_by_gsolve_pcg
