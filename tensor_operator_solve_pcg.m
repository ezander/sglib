function [X,flag,relres,iter,info]=tensor_operator_solve_pcg( A, F, varargin )

options=varargin2options( varargin{:} );
[M,options]=get_option( options, 'M', [] );
[abstol,options]=get_option( options, 'abstol', 1e-6 );
[reltol,options]=get_option( options, 'reltol', 1e-6 );
[maxiter,options]=get_option( options, 'maxiter', 100 );
[truncate_options,options]=get_option( options, 'truncate_options', {} );
[X_true,options]=get_option( options, 'true_sol', [] );
check_unsupported_options( options, mfilename );


null_vector=@tensor_null;
add=@tensor_add;
prec_solve=@tensor_operator_solve_elementary;
apply_operator=@tensor_operator_apply;
scale=@tensor_scale;
if isnumeric(F)
    truncate=@tensor_truncate;
    inner_prod=@(a,b)(a'*b);
    vec_norm=@norm;
else
    truncate=@tensor_truncate;
    inner_prod=@tensor_scalar_product;
    vec_norm=@tensor_norm;
end

iter=0;
flag=0;

Xc=null_vector(F);
Rc=add( F, apply_operator( A, Xc ), -1);
Zc=prec_solve( M, Rc );
Pc=Zc;

initres=vec_norm( Rc );

do_stats=true;
if do_stats
    info.res_norm=[initres];
    info.res_relnorm=[1];
    info.res_accuracy=[];
    info.res_relacc=[];
    info.update_ratio=[];
    info.sol_err=[];
    info.sol_relerr=[];
    if ~isempty( X_true )
        info.sol_err=[vec_norm( X_true )];
        info.sol_relerr=[1];
    end
end

while true
    alpha=inner_prod(Rc,Zc)/inner_prod(Pc,apply_operator(A,Pc));
    Xn=add(Xc,Pc,alpha);
    Rn=add(Rc,apply_operator(A,Pc),-alpha);
    
    Xn=truncate( Xn, truncate_options );
    Rn=truncate( Rn, truncate_options );

    normres=vec_norm( Rn );
    relres=normres/initres;
    
    if do_stats
        % Proposed update is DY=alpha*Pc
        % actual update is DX=T(Xn)-Xc;
        % update ratio is (DX,DY)/(DY,DY) should be near one
        % no progress if near 0
        DY=scale( Pc, alpha );
        DX=add( Xn, Xc, -1 );
        ur=inner_prod( DX, DY )/inner_prod( DY, DY );

        TRn=add( F, apply_operator( A, Xn ), -1 );
        normres=vec_norm( TRn );
        relres=normres/initres;
        
        DRn=add( Rn, add( F, apply_operator( A, Xn ), -1 ), -1 );
        ra=vec_norm( DRn );
        
        info.res_norm=[info.res_norm, normres];
        info.res_relnorm=[info.res_relnorm, relres];
        info.res_accuracy=[info.res_accuracy, ra];
        info.res_relacc=[info.res_relacc, ra/normres];
        info.update_ratio=[info.update_ratio, ur];
        
        if ~isempty( X_true ) 
            solerr=vec_norm( add( Xn, X_true, -1 ) );
            solrelerr=solerr/vec_norm( X_true );
            info.sol_err=[info.sol_err, solerr];
            info.sol_relerr=[info.sol_relerr, solrelerr];
        end
        
    end
    
    if normres<abstol || relres<reltol; break; end
    
    urc=iter-50;
    if ur<.1 && urc>10
        warning( 'a:b', 'update ratio too small ...' );
        flag=-1;
        break;
    end
    
    
    Zn=prec_solve(M,Rn);
    beta=inner_prod(Rn,Zn)/inner_prod(Rc,Zc);
    Pn=add(Zn,Pc,beta);
    
    % truncate all iteration variables
    Xc=truncate( Xn, truncate_options );
    Pc=truncate( Pn, truncate_options );
    Rc=truncate( Rn, truncate_options );
    Zc=truncate( Zn, truncate_options );

    % increment and check iteration counter
    iter=iter+1;
    if iter>maxiter
        flag=1;
        break;
    end

    
    if false && mod(iter,100)==0
        keyboard
    end
end
X=truncate( Xn, truncate_options );

