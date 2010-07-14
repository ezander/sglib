% determine: how is contractivity determined by update ratio
clear
model_1d_small
N=100;
m_f=0; p_f=1; l_f=2;
m_g=0; p_g=1; l_g=2;
m_h=0; p_h=1; l_h=2;

res=[];
for ratio=0.1:0.05:1.5
    %ratio=0.3;
    [a,b]=beta_find_ratio(ratio);
    dist_k={'beta', {a,b}, 0.0001, 1.0 };
    
    m_k=10;
    p_k=2;
    l_k=10;
    
    define_geometry
    discretize_model
    setup_equation
    
    S=operator_size(Ki);
    Pi_inv=stochastic_precond_mean_based(Ki);
    
    x0=rand(S(1),1);
    [rat,flag,iter]=simple_iteration_normest( Ki, Pi_inv, x0 );
    
    if flag
        disp( 'did NOT converge' );
    else
        fprintf( 'converged after %d iterations\n', iter );
    end
    [ratio,rat]
    res=[res; ratio, rat];
    plot( res(:,1), res(:,2), '-x' );
    xlim( [0,1.5] );
    ylim( [0,4.5] );
    drawnow;
end
