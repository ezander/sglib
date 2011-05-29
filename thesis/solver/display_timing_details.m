function display_timing_details(t)

if ~exist( 't', 'var' )
    global info_tp
    t=info_tp{1}.timers;
end

strvarexpand( 'solver         $t.gen_solver_simple$' )

strvarexpand( 'truncate       $t.tensor_truncate$' )
strvarexpand( 'truncate.qr    $t.qr_internal$' )
strvarexpand( 'truncate.svd   $t.tensor_truncate_svd__svd$' )

strvarexpand( 'operator_app   $t.tensor_operator_apply_elementary$' )
strvarexpand( 'operator_app.P $t.operator_lusolve$' )



%                    gen_solver_simple: 181.657771
%                       gss_oper_apply: 118.992336
%                       gss_prec_apply: 11.539005
%                       operator_apply: 130.48268
%                          qr_internal: 92.148066
%     tensor_operator_apply_elementary: 12.361807
%                      tensor_truncate: 133.502794
%             tensor_truncate_svd__svd: 23.604566
%             
            