function [PMi_inv, PKi, PFi]=precondition_system( Mi, Mi_inv, Ki, Fi, prec_strat, prec_options )

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
        PKi=operator_compose( Mi_inv, Ki );
        PKi=operator_compose( Mi, PKi, 'tensor_sum', false );
        PMi_inv=Mi_inv;
        PFi=Fi;
    case 'inside_res'
        PKi=operator_compose( Mi_inv, Ki );
        PMi_inv={speye(size(Ki{1,1})),speye(size(Ki{1,2}))};
        PFi=operator_apply( Mi_inv, Fi );
    case 'ilu'
        [MiC_inv,MiC,info]=stochastic_preconditioner( Ki, 'decomp_type', 'ilu', 'decomp_options', prec_options );
        PKi=operator_compose( MiC_inv, Ki );
        PKi=operator_compose( MiC, PKi, 'tensor_sum', false );
        PMi_inv=Mi_inv;
        PFi=Fi;
    case 'ilu_res'
        [MiC_inv,MiC,info]=stochastic_preconditioner( Ki, 'decomp_type', 'ilu', 'decomp_options', prec_options );
        PKi=operator_compose( MiC_inv, Ki );
        PMi_inv=operator_compose( Mi_inv, MiC );
        PFi=operator_apply( MiC_inv, Fi );
    otherwise
        error( 'unknown prec_strat' );
end
