disp( 'attention: check goodness of computation here' );
R1=gvector_add( Fi, operator_apply( Ki, Ui ), -1 );
R2=gvector_add( Fi, operator_apply( Ki, Ui_true ), -1 );

relerr=gvector_error( Ui, Ui_true, 'relerr', true );
if is_tensor(Ui)
    k=tensor_rank(Ui);
end

if exist('eps','var') && eps>0
    R=relerr/eps;
else
    R=1;
end
