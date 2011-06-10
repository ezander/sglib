function display_timing_details(t)

if ~exist( 't', 'var' )
    global info_tp
    t=info_tp{1}.timers;
end

strvarexpand( 'solver         $t.gsolve' )

strvarexpand( 'truncate       $t.tensor_truncate$' )
strvarexpand( 'truncate.qr    $t.qr_internal$' )
strvarexpand( 'truncate.svd   $t.tensor_truncate_svd__svd$' )

strvarexpand( 'operator_app   $t.tensor_operator_apply_elementary$' )
strvarexpand( 'operator_app.P $t.operator_lusolve$' )
            
