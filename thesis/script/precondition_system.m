function [PMi_inv, PKi, PFi]=precondition_system( Mi_inv, Ki, Fi, prec_strat, prec_options )

if nargin<4
    prec_strat='basic';
end
if nargin<5
    prec_options={};
end

switch prec_strat
    case 'basic'
        PKi=Ki;
        PMi_inv=Mi_inv;
        PFi=Fi;
    case 'inside'
        PKi=tensor_operator_compose( Mi_inv, Ki );
        PMi_inv={speye(size(Ki{1,1})),speye(size(Ki{1,2}))};
        PFi=tensor_operator_apply( Mi_inv, Fi );
    case 'ilu'
        [Mi2_inv,Mi2,info]=stochastic_precond_mean_based( Ki, 'decomp_type', 'ilu', 'decomp_options', prec_options );
        PKi=tensor_operator_compose( Mi2_inv, Ki );
        PMi_inv=tensor_operator_compose( Mi_inv, Mi2 );
        PFi=tensor_operator_apply( Mi2_inv, Fi );
    otherwise
        error( 'unknown prec_strat' );
end
