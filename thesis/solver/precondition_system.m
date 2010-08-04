function [PMi_inv, PKi, PFi]=precondition_system( Mi_inv, Ki, Fi, decomp_type, decomp_options )

if nargin<4
    decomp_type='none';
end
if nargin<5
    decomp_options={};
end

switch decomp_type
    case 'none'
        PKi=Ki;
        PMi_inv=Mi_inv;
        PFi=Fi;
    case 'same'
        PKi=tensor_operator_compose( Mi_inv, Ki );
        PMi_inv={speye(size(Ki{1,1})),speye(size(Ki{1,2}))};
        PFi=tensor_operator_apply( Mi_inv, Fi );
    otherwise
        [Mi2_inv,Mi2,info]=stochastic_precond_mean_based( Ki, 'decomp_type', decomp_type, 'decomp_options', decomp_options );
        
        PKi=tensor_operator_compose( Mi2_inv, Ki );
        PMi_inv=tensor_operator_compose( Mi_inv, Mi2 );
        PFi=tensor_operator_apply( Mi2_inv, Fi );
end
