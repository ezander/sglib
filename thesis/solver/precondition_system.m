function [PMi_inv, PKi, PFi]=precondition_system( Mi_inv, Ki, Fi, decomp_type, decomp_options )

% ilu_setup=struct( 'type', 'nofill', 'milu', 'row', 'droptol', 2e-2 );
% ilu_setup=struct( 'type', 'ilutp', 'milu', 'row', 'droptol', 2e-2 );
% prec_options1={'lu'};
% prec_options2={};
% prec_options1={'ilu'};
% prec_options2={'ilu'};

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
        [M2_inv,M2,info]=stochastic_precond_mean_based( A, 'decomp_type', decomp_type, 'decomp_type', decomp_options );
        
        PKi=tensor_operator_compose( Mi2_inv, Ki );
        PMi_inv=tensor_operator_compose( Mi_inv, Mi2 );
        PFi=tensor_operator_apply( Mi2_inv, Fi );
end
